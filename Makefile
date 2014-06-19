
# OCaml part

packages = extlib
files = $(shell ls *.ml)
name = grapher

camlc   = ocamlfind ocamlc   $(lib)
camlopt = ocamlfind ocamlopt $(lib)
camldep = ocamlfind ocamldep
lib = -package $(packages)

objs    = $(files:.ml=.cmo)
optobjs = $(files:.ml=.cmx)

all: $(name)

$(name): $(optobjs)
	$(camlopt) `ocamldep-sorter $^ < .depend` -linkpkg -o $@

.SUFFIXES: .ml .mli .cmo .cmi .cmx

.ml.cmo:
	$(camlc) -c $<
.mli.cmi:
	$(camlc) -c $<
.ml.cmx:
	$(camlopt) -c $<


basedir = $(shell pwd)

data/bitcoin-blocks.csv:
	# 36 is for 6 hours resolution
	wget -q http://blockexplorer.com/q/nethash/18 -O data/bitcoin-blocks.csv

data/bitcoin-blocks-wo-header.csv: data/bitcoin-blocks.csv
	tail -n +16 data/bitcoin-blocks.csv > data/bitcoin-blocks-wo-header.csv

data/bitcoin-blocks.dat: data/bitcoin-blocks-wo-header.csv
	rm -f $@
	ruby $(basedir)/csv-unixtime-to-dat.rb data/bitcoin-blocks-wo-header.csv $@

data/litecoin-blocks:
	wget -q http://komar.lexs.blasux.ru/litecoin-blocks-difficulty -O $@

data/litecoin-blocks.dat: data/litecoin-blocks
	ruby $(basedir)/unixtime-to-dat.rb data/litecoin-blocks $@

data/btc-e-ltc-usd.dat:
	ruby $(basedir)/get-btce-ltc-usd.rb > $@

data/btc-e-ltc-btc.dat:
	ruby $(basedir)/get-btce-ltc-btc.rb > $@

data/btc-e-btc-usd.dat~:
	ruby $(basedir)/get-btce-btc-usd.rb > $@
	cat $(basedir)/btce-btc-usd-from-bitcoincharts.dat >> $@

data/btc-e-btc-usd.dat: data/btc-e-btc-usd.dat~
	sort data/btc-e-btc-usd.dat~ | uniq -w 8 > $@

data/mtgox-btc-usd.dat~:
	ruby $(basedir)/get-mtgox-btc-usd.rb > $@
	cat $(basedir)/mtgox-btc-usd.dat >> $@

data/mtgox-btc-usd.dat: data/mtgox-btc-usd.dat~
	sort data/mtgox-btc-usd.dat~ | uniq -w 8 > $@

data/mtgox-and-btce.dat: data/btc-e-btc-usd.dat data/mtgox-btc-usd.dat
	bash -c "join <(sort -k1,1 data/btc-e-btc-usd.dat) <(sort -k1,1 data/mtgox-btc-usd.dat) > $@"

energy_cost=0.12

data/avalion_asic_2_bitcoin_mining_cost.dat: grapher data/bitcoin-blocks.dat
	$(basedir)/grapher -self-cost -coins-type bitcoins -hashrate 82000000000 -power 700 -blocks-data data/bitcoin-blocks.dat -energy-cost $(energy_cost) > $@

data/avalion_asic_2_bitcoin_mining_cost_with_1_year_amortization.dat: grapher data/bitcoin-blocks.dat
	$(basedir)/grapher -amortized-self-cost 31536000. -coins-type bitcoins -hashrate 82000000000 -power 700 -blocks-data data/bitcoin-blocks.dat -energy-cost $(energy_cost) -hardware-cost 1499 > $@

data/terraminer_iv_bitcoin_mining_cost.dat: grapher data/bitcoin-blocks.dat
	$(basedir)/grapher -self-cost -coins-type bitcoins -hashrate 2000000000000 -power 2200 -blocks-data data/bitcoin-blocks.dat -energy-cost $(energy_cost) > $@

data/terraminer_iv_bitcoin_mining_cost_with_1_year_amortization.dat: grapher data/bitcoin-blocks.dat
	$(basedir)/grapher -amortized-self-cost 31536000. -coins-type bitcoins -hashrate 2000000000000 -power 2200 -blocks-data data/bitcoin-blocks.dat -energy-cost $(energy_cost) -hardware-cost 5999 > $@

data/ati_7970_bitcoin_mining_cost.dat: grapher data/bitcoin-blocks.dat
	$(basedir)/grapher -self-cost -coins-type bitcoins -hashrate 685000000 -power 250 -blocks-data data/bitcoin-blocks.dat -energy-cost $(energy_cost) > $@

data/ati_7970_bitcoin_mining_cost_with_1_year_amortization.dat: grapher data/bitcoin-blocks.dat
	$(basedir)/grapher -amortized-self-cost 31536000. -coins-type bitcoins -hashrate 685000000 -power 250  -blocks-data data/bitcoin-blocks.dat -energy-cost $(energy_cost) -hardware-cost 399 > $@

data/ati_5970_bitcoin_mining_cost.dat: grapher data/bitcoin-blocks.dat
	$(basedir)/grapher -self-cost -coins-type bitcoins -hashrate 530000000 -power 294 -blocks-data data/bitcoin-blocks.dat -energy-cost $(energy_cost) > $@

data/ati_5970_bitcoin_mining_cost_with_1_year_amortization.dat:grapher data/bitcoin-blocks.dat
	$(basedir)/grapher -amortized-self-cost 31536000. -coins-type bitcoins -hashrate 530000000 -power 294  -blocks-data data/bitcoin-blocks.dat -energy-cost $(energy_cost) -hardware-cost 1000 > $@

data/pentium_dual-core_e5400_mining_cost.dat: grapher data/bitcoin-blocks.dat
	$(basedir)/grapher -self-cost -coins-type bitcoins -hashrate 2270000 -power 65 -blocks-data data/bitcoin-blocks.dat -energy-cost $(energy_cost) > $@

data/avalon_asic_2_bitcoin_profitability.dat: grapher data/bitcoin-blocks.dat data/btc-e-btc-usd.dat
	$(basedir)/grapher -profitability -coins-type bitcoins -hashrate 82000000000 -power 700 -blocks-data data/bitcoin-blocks.dat -market-rate-data data/btc-e-btc-usd.dat -energy-cost $(energy_cost) > $@

data/terraminer_iv_bitcoin_profitability.dat: grapher data/bitcoin-blocks.dat data/btc-e-btc-usd.dat
	$(basedir)/grapher -profitability -coins-type bitcoins -hashrate 2000000000000 -power 2200 -blocks-data data/bitcoin-blocks.dat -market-rate-data data/btc-e-btc-usd.dat -energy-cost $(energy_cost) > $@

data/ati_7970_bitcoin_profitability.dat: grapher data/bitcoin-blocks.dat data/btc-e-btc-usd.dat
	$(basedir)/grapher -profitability -coins-type bitcoins -hashrate 685000000 -power 250 -blocks-data data/bitcoin-blocks.dat -market-rate-data data/btc-e-btc-usd.dat -energy-cost $(energy_cost) > $@

data/ati_5970_bitcoin_profitability.dat: grapher data/bitcoin-blocks.dat data/mtgox-btc-usd.dat
	$(basedir)/grapher -profitability -coins-type bitcoins -hashrate 530000000 -power 294 -blocks-data data/bitcoin-blocks.dat -market-rate-data data/mtgox-btc-usd.dat -energy-cost $(energy_cost) > $@

data/pentium_dual-core_e5400_bitcoin_profitability.dat: grapher data/bitcoin-blocks.dat data/mtgox-btc-usd.dat
	$(basedir)/grapher -profitability -coins-type bitcoins -hashrate 2270000 -power 65 -blocks-data data/bitcoin-blocks.dat -market-rate-data data/mtgox-btc-usd.dat -energy-cost $(energy_cost) > $@

data/ati_7970_litecoin_profitability.dat: grapher data/litecoin-blocks.dat data/btc-e-ltc-usd.dat
	$(basedir)/grapher -profitability -coins-type litecoins -hashrate 650000 -power 250 -blocks-data data/litecoin-blocks.dat -market-rate-data data/btc-e-ltc-usd.dat -energy-cost $(energy_cost) > $@

data/ghash_bitcoin_profitability.dat: grapher data/bitcoin-blocks.dat data/mtgox-btc-usd.dat
	$(basedir)/grapher -profitability -coins-type bitcoins -hashrate 1000000000 -power 0 -blocks-data data/bitcoin-blocks.dat -market-rate-data data/mtgox-btc-usd.dat -energy-cost $(energy_cost) > $@

data/ati_7970_litecoin_mining_cost.dat: grapher data/litecoin-blocks.dat
	$(basedir)/grapher -self-cost -coins-type litecoins -hashrate 650000 -power 250 -blocks-data data/litecoin-blocks.dat -energy-cost $(energy_cost) > $@

data/ati_7970_litecoin_mining_cost_with_1_year_amortization.dat: grapher data/litecoin-blocks.dat
	$(basedir)/grapher -amortized-self-cost 31536000. -coins-type litecoins -hashrate 650000 -power 250 -blocks-data data/litecoin-blocks.dat -energy-cost $(energy_cost) -hardware-cost 399 > $@

data/mining-hardware-recoupment.dat: grapher data/bitcoin-blocks.dat
	$(basedir)/grapher -mining-hardware-recoupment -difficulty `tail -n1 data/bitcoin-blocks.dat | cut -d ' ' -f 5` > $@

img/bitfinex-lendbook-usd-all-time.png \
  img/bitfinex-lendbook-btc-all-time.png \
  img/bitfinex-lendbook-ltc-all-time.png: \
    draw-bitfinex-lendbook.gnuplot \
    data/bitfinex-lendbook-usd.dat \
    data/bitfinex-lendbook-btc.dat \
    data/bitfinex-lendbook-ltc.dat
	$(basedir)/draw-bitfinex-lendbook.gnuplot

img/bitcoin-and-litecoin-profitability.png \
  img/bitcoin-difficulty-changes.png \
  img/bitcoin-mining-cost-from-20130201-to-now.png \
  img/bitcoin-mining-cost-from-20140201-to-now.png \
  img/bitcoin-mining-cost-to-20130201.png \
  img/bitcoin-price-needed-to-cover-hardware-cost.png \
  img/bitcoin-profitability-from-20130201-to-now.png \
  img/bitcoin-profitability-from-20130801-to-now.png \
  img/bitcoin-profitability-from-20140201-to-now.png \
  img/bitcoin-profitability-to-20130201.png \
  img/bitcoin-self-cost-logscale.png \
  img/ghash-profitability-from-20130701-to-now.png \
  img/litecoin-mining-cost-logscale.png \
  img/litecoin-mining-cost.png \
  img/mtgox-btce-difference.png: \
    draw-graphs.gnuplot \
    data/avalion_asic_2_bitcoin_mining_cost.dat \
    data/avalion_asic_2_bitcoin_mining_cost_with_1_year_amortization.dat \
    data/terraminer_iv_bitcoin_mining_cost.dat \
    data/terraminer_iv_bitcoin_mining_cost_with_1_year_amortization.dat \
    data/ati_7970_bitcoin_mining_cost.dat \
    data/ati_7970_bitcoin_mining_cost_with_1_year_amortization.dat \
    data/ati_5970_bitcoin_mining_cost.dat \
    data/ati_5970_bitcoin_mining_cost_with_1_year_amortization.dat \
    data/pentium_dual-core_e5400_mining_cost.dat \
    data/avalon_asic_2_bitcoin_profitability.dat \
    data/terraminer_iv_bitcoin_profitability.dat \
    data/ati_7970_bitcoin_profitability.dat \
    data/ati_5970_bitcoin_profitability.dat \
    data/pentium_dual-core_e5400_bitcoin_profitability.dat \
    data/ati_7970_litecoin_profitability.dat \
    data/ghash_bitcoin_profitability.dat \
    data/ati_7970_litecoin_mining_cost.dat \
    data/ati_7970_litecoin_mining_cost_with_1_year_amortization.dat \
    data/mining-hardware-recoupment.dat \
    data/mtgox-and-btce.dat
	$(basedir)/draw-graphs.gnuplot

графики/доходность-гигахеша-на-майнинге-биткоинов-с-20130701-по-сегодняшний-день.png \
  графики/доходность-майнинга-биткоинов-до-20130201.png \
  графики/доходность-майнинга-биткоинов-и-лайткоинов.png \
  графики/доходность-майнинга-биткоинов-с-20130201-по-сегодняшний-день.png \
  графики/доходность-майнинга-биткоинов-с-20130801-по-сегодняший-день.png \
  графики/доходность-майнинга-биткоинов-с-20140201-по-сегодняшний-день.png \
  графики/изменение-сложности-майнинга-биткоинов.png \
  графики/курс-биткоина.png \
  графики/необходимая-цена-биткоина-для-покрытия-стоимости-оборудования.png \
  графики/разнциа-между-mtgox-и-btce.png \
  графики/себестоимость-майнинга-биткоинов-до-20130201.png \
  графики/себестоимость-майнинга-биткоинов-логарифмическая-шкала-600x400.png \
  графики/себестоимость-майнинга-биткоинов-логарифмическая-шкала.png \
  графики/себестоимость-майнинга-биткоинов-с-20130210-по-сегодняшний-день.png \
  графики/себестоимость-майнинга-биткоинов-с-20140201-по-сегодняшний-день.png \
  графики/себестоимость-майнинга-лайткоинов.png: \
    draw-graphs-ru.gnuplot \
    data/avalion_asic_2_bitcoin_mining_cost.dat \
    data/avalion_asic_2_bitcoin_mining_cost_with_1_year_amortization.dat \
    data/terraminer_iv_bitcoin_mining_cost.dat \
    data/terraminer_iv_bitcoin_mining_cost_with_1_year_amortization.dat \
    data/ati_7970_bitcoin_mining_cost.dat \
    data/ati_7970_bitcoin_mining_cost_with_1_year_amortization.dat \
    data/ati_5970_bitcoin_mining_cost.dat \
    data/ati_5970_bitcoin_mining_cost_with_1_year_amortization.dat \
    data/pentium_dual-core_e5400_mining_cost.dat \
    data/avalon_asic_2_bitcoin_profitability.dat \
    data/terraminer_iv_bitcoin_profitability.dat \
    data/ati_7970_bitcoin_profitability.dat \
    data/ati_5970_bitcoin_profitability.dat \
    data/pentium_dual-core_e5400_bitcoin_profitability.dat \
    data/ati_7970_litecoin_profitability.dat \
    data/ghash_bitcoin_profitability.dat \
    data/ati_7970_litecoin_mining_cost.dat \
    data/ati_7970_litecoin_mining_cost_with_1_year_amortization.dat \
    data/mining-hardware-recoupment.dat
	$(basedir)/draw-graphs-ru.gnuplot

.PHONY: charts

charts: \
  img/bitfinex-lendbook-usd-all-time.png \
  img/bitfinex-lendbook-btc-all-time.png \
  img/bitfinex-lendbook-ltc-all-time.png \
  img/bitcoin-and-litecoin-profitability.png \
  img/bitcoin-difficulty-changes.png \
  img/bitcoin-mining-cost-from-20130201-to-now.png \
  img/bitcoin-mining-cost-from-20140201-to-now.png \
  img/bitcoin-mining-cost-to-20130201.png \
  img/bitcoin-price-needed-to-cover-hardware-cost.png \
  img/bitcoin-profitability-from-20130201-to-now.png \
  img/bitcoin-profitability-from-20130801-to-now.png \
  img/bitcoin-profitability-from-20140201-to-now.png \
  img/bitcoin-profitability-to-20130201.png \
  img/bitcoin-self-cost-logscale.png \
  img/ghash-profitability-from-20130701-to-now.png \
  img/litecoin-mining-cost-logscale.png \
  img/litecoin-mining-cost.png \
  img/mtgox-btce-difference.png \
  графики/доходность-гигахеша-на-майнинге-биткоинов-с-20130701-по-сегодняшний-день.png \
  графики/доходность-майнинга-биткоинов-до-20130201.png \
  графики/доходность-майнинга-биткоинов-и-лайткоинов.png \
  графики/доходность-майнинга-биткоинов-с-20130201-по-сегодняшний-день.png \
  графики/доходность-майнинга-биткоинов-с-20130801-по-сегодняший-день.png \
  графики/доходность-майнинга-биткоинов-с-20140201-по-сегодняшний-день.png \
  графики/изменение-сложности-майнинга-биткоинов.png \
  графики/курс-биткоина.png \
  графики/необходимая-цена-биткоина-для-покрытия-стоимости-оборудования.png \
  графики/разнциа-между-mtgox-и-btce.png \
  графики/себестоимость-майнинга-биткоинов-до-20130201.png \
  графики/себестоимость-майнинга-биткоинов-логарифмическая-шкала-600x400.png \
  графики/себестоимость-майнинга-биткоинов-логарифмическая-шкала.png \
  графики/себестоимость-майнинга-биткоинов-с-20130210-по-сегодняшний-день.png \
  графики/себестоимость-майнинга-биткоинов-с-20140201-по-сегодняшний-день.png \
  графики/себестоимость-майнинга-лайткоинов.png


clean:
	-rm -f *.cm[ioxa] *.cmx[as] *.o *.a *~ $(name)
	-rm -f .depend

.depend: $(files)
	$(camldep) $(lib) $(files:.ml=.mli) $(files) > .depend

FORCE:

-include .depend
