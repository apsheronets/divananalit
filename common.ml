
type coins =
  | Bitcoin
  | Litecoin

let time_for_reward difficulty hashrate = difficulty *. (2. ** 32.) /. hashrate
let energy_for_reward difficulty hashrate power = (time_for_reward difficulty hashrate) *. power
let energy_per_coin reward difficulty hashrate power = (energy_for_reward difficulty hashrate power) /. reward

let course reward difficulty hashrate power power_rate =
  (energy_per_coin reward difficulty hashrate power) *. (power_rate /. 3600000.)

let profit_per_second reward difficulty hashrate power power_rate =
  (reward *. course reward difficulty hashrate power power_rate) /.
  (time_for_reward difficulty hashrate)

let amortization_per_second time hardware_cost =
  hardware_cost /. time

let amortizated_course time hardware_cost reward difficulty hashrate power power_rate =
  ((profit_per_second reward difficulty hashrate power power_rate +. amortization_per_second time hardware_cost) *. (time_for_reward difficulty hashrate)) /. reward

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

let amortizated_income time hardware_cost market_rate reward difficulty hashrate power power_rate =
  let course = amortizated_course time hardware_cost reward difficulty hashrate power power_rate in
  let course = market_rate -. course in
  (reward *. course) /.
  (time_for_reward difficulty hashrate)

let amortizated_income_per_day time hardware_cost makret_rate reward difficulty hashrate power power_rate =
  (amortizated_income time hardware_cost makret_rate reward difficulty hashrate power power_rate) *. 60. *. 60. *. 24.

let difficulty_for_bitcoin_network_hashrate hashrate =
  let time = 600. in (* ten minutes *)
  (hashrate *. time) /. (2. ** 32.)

let reward_for_bitcoin_block block_number =
  if block_number < 210000 then 50.
  else if block_number < 420000 then 25.
  else if block_number < 630000 then 12.5
  else if block_number < 840000 then 6.25
  else 0.

let reward_for_litecoin_block block_number =
  if block_number > 840000000 then 0.
  else 50. /. float_of_int (1 + (block_number / 840000))
