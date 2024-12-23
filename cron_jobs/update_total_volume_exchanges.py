import ccxt
import psycopg2

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
    'cryptocom', 'bingx', 'bitmart', 'bitstamp'
]

def get_total_volume(exchange_name):
   exchange = getattr(ccxt, exchange_name)()
   tickers = exchange.fetch_tickers()
   #print(tickers)
   if exchange_name == "coinbase" :
      total_volume = sum(float(ticker['info']['volume_24h']) for ticker in tickers.values())
   elif exchange_name == "bitfinex":
      total_volume = sum(float(ticker['baseVolume']) for ticker in tickers.values() if 'baseVolume' in ticker)
   elif exchange_name == 'cryptocom':
      total_volume = sum(float(ticker['quoteVolume']) for ticker in tickers.values() if 'quoteVolume' in ticker and ticker['quoteVolume'] is not None)
   else:
      total_volume = sum(float(ticker['quoteVolume']) for ticker in tickers.values() if 'quoteVolume' in ticker)
   total_volume = round(total_volume, 2)
   return total_volume

for exchange in EXCHANGES:
   total_volume = get_total_volume(exchange)
   cursor.execute(
      "UPDATE exchanges SET volume_24h = %s WHERE id = %s",
      (total_volume, exchange)
      )
   conn.commit()
   print(f"Total trading volume of {exchange}: {total_volume}")

cursor.close()
conn.close()
# 0 * * * * /usr/bin/python3 /root/update_total_volume_exchanges.py