import ccxt
import psycopg2
from psycopg2 import extras
from concurrent.futures import ProcessPoolExecutor, as_completed

conn = psycopg2.connect(
    dbname='',
    user='',
    password='',
    host='servergw.kozow.com',
    port='5432'
)
cursor = conn.cursor()

EXCHANGES = [
    'binance', 'coinbase', 'bybit', 'okx', 'upbit', 'huobi',
    'kraken', 'gateio', 'bitfinex', 'kucoin', 'mexc', 'bitget',
    'cryptocom', 'bingx', 'bitmart', 'bitstamp', 'gemini'
]

data = {}

def get_metrics(exchange_name):
    try:
        exchange = getattr(ccxt, exchange_name)()
        tickers = exchange.fetch_tickers()

        local_data = {}
        for symbol, ticker in tickers.items():
            if '/USDT' in symbol:
                base_symbol = symbol.split('/')[0]
                price = ticker.get('last', None)
                volume_24h = ticker.get('quoteVolume', None)
                change_24h = ticker.get('percentage', None)

                if price is None or volume_24h is None or change_24h is None:
                    continue

                volume_24h = round(volume_24h, 2)
                change_24h = round(change_24h, 2)

                if base_symbol not in local_data:
                    local_data[base_symbol] = {
                        'price': price,
                        'volume_24h': volume_24h,
                        'change_24h': change_24h
                    }
                else:
                    local_data[base_symbol]['volume_24h'] += volume_24h
        
        return local_data
    except Exception as e:
        print(f"Error fetching metrics for {exchange_name}: {e}")
        return {}

def update_database(data):
    try:
        update_values = [
            (metrics['price'], metrics['volume_24h'], metrics['change_24h'], base_symbol)
            for base_symbol, metrics in data.items()
        ]
        
        query = '''
            UPDATE cryptos
            SET price = data.price, volume_24h = data.volume_24h, change_24h = data.change_24h
            FROM (VALUES %s) AS data(price, volume_24h, change_24h, symbol)
            WHERE cryptos.symbol = data.symbol
        '''
        extras.execute_values(
            cursor, query, update_values, template=None, page_size=100
        )
        conn.commit()
        print(f"Updated {len(update_values)} rows in the database.")
    except Exception as e:
        print(f"Error updating database: {e}")
        conn.rollback()
if __name__ == "__main__":
   with ProcessPoolExecutor(max_workers=10) as executor:
      future_to_exchange = {executor.submit(get_metrics, exchange): exchange for exchange in EXCHANGES}

      for future in as_completed(future_to_exchange):
         exchange = future_to_exchange[future]
         try:
               exchange_data = future.result()
               for key, value in exchange_data.items():
                  if key not in data:
                     data[key] = value
                  else:
                     data[key]['volume_24h'] += value['volume_24h']
         except Exception as e:
               print(f"Error processing data for {exchange}: {e}")

   update_database(data)

   cursor.close()
   conn.close()