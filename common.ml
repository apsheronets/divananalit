
let time_for_reward difficulty hashrate = difficulty *. (2. ** 32.) /. hashrate
let to_usd x = x /. 30.
let energy_for_reward difficulty hashrate power = (time_for_reward difficulty hashrate) *. power
let energy_per_coin reward difficulty hashrate power = (energy_for_reward difficulty hashrate power) /. reward

let course reward difficulty hashrate power power_rate =
  (energy_per_coin reward difficulty hashrate power) *. (to_usd (power_rate /. 3600000.))

let proofit_per_second reward difficulty hashrate power power_rate =
  (reward *. course reward difficulty hashrate power power_rate) /.
  (time_for_reward difficulty hashrate)

let amortization_per_second hardware_cost =
  let years = 1. in
  hardware_cost /. (years *. 365. *. 24. *. 60. *. 60.)

let amortizated_course hardware_cost reward difficulty hashrate power power_rate =
  ((proofit_per_second reward difficulty hashrate power power_rate +. amortization_per_second hardware_cost) *. (time_for_reward difficulty hashrate)) /. reward

let coins_income reward difficulty hashrate =
  reward /.
  (time_for_reward difficulty hashrate)

let coins_income_per_day reward difficulty hashrate =
  (coins_income reward difficulty hashrate) *. 60. *. 60. *. 24.

let income market_rate reward difficulty hashrate power power_rate =
  let course = course reward difficulty hashrate power power_rate in
  let course = market_rate -. course in
  (reward *. course) /.
  (time_for_reward difficulty hashrate)

let income_per_day market_rate reward difficulty hashrate power power_rate =
  (income market_rate reward difficulty hashrate power power_rate) *. 60. *. 60. *. 24.

let amortizated_income hardware_cost market_rate reward difficulty hashrate power power_rate =
  let course = amortizated_course hardware_cost reward difficulty hashrate power power_rate in
  let course = market_rate -. course in
  (reward *. course) /.
  (time_for_reward difficulty hashrate)

let amortizated_income_per_day hardware_cost makret_rate reward difficulty hashrate power power_rate =
  (amortizated_income hardware_cost makret_rate reward difficulty hashrate power power_rate) *. 60. *. 60. *. 24.

let difficulty_for_hashrate hashrate =
  let time = 600. in (* ten minutes *)
  (hashrate *. time) /. (2. ** 32.)

let reward_for_bitcoin_block block_number =
  if block_number < 210000 then 50.
  else if block_number < 420000 then 25.
  else if block_number < 630000 then 12.5
  else if block_number < 840000 then 6.25
  else 0.

let red = 0xFF0000
let green = 0x00AA00
let blue = 0x0000FF

(*let difficulty = 11187257.46136079*) (* before asics *)
let bitcoin_reward = 25.
let litecoin_reward = 50.
let difficulty = 21335329.11398300
let litecoin_difficulty = 909.30145843
let network_hashrate = 160.01 *. 1000000000000.
let current_blocks_per_second = 153. /. 24. /. 60. /. 60.
let market_rate = 70.
let litecoin_market_rate = 2.5

