
module P = Gnuplot
open Parse_args

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

let red = 0xFF0000
let green = 0x00AA00
let blue = 0x0000FF

(*let difficulty = 11187257.46136079*) (* before asics *)
let bitcoin_reward = 25.
let litecoin_reward = 50.
let difficulty = 21335329.11398300
let litecoin_difficulty = 841.46756083
let network_hashrate = 160.01 *. 1000000000000.
let current_blocks_per_second = 153. /. 24. /. 60. /. 60.
let market_rate = 90.
let litecoin_market_rate = 2.7

let asics_income () =
  let g = P.init ?offline:(offline 1) ~xsize:800. ~ysize:600. (device 1) in
  P.box g;
  P.box g ~x:[P.tics ~grid:true ()] ~y:[P.tics ~grid:true ()];
  P.xlabel g "count of asics";
  P.ylabel g "income per day, $";

  let income_per_day x =
    let network_hashrate = network_hashrate +. (50000000000. *. x) in
    let difficulty = difficulty_for_hashrate network_hashrate in
    income_per_day market_rate bitcoin_reward difficulty 50000000000. 0. 3. in

  let amortizated_income_per_day x =
    let network_hashrate = network_hashrate +. (50000000000. *. x) in
    let difficulty = difficulty_for_hashrate network_hashrate in
    amortizated_income_per_day 2499. market_rate bitcoin_reward difficulty 50000000000. 0. 3. in

  P.color g green;
  P.fx g income_per_day 10000. 100000.;
  P.color g red;
  P.fx g amortizated_income_per_day 10000. 100000.;

  P.close g

let asics_course () =
  let g = P.init ?offline:(offline 1) ~xsize:800. ~ysize:600. (device 1) in
  P.box g;
  P.box g ~x:[P.tics ~grid:true ()] ~y:[P.tics ~grid:true ()];
  P.xlabel g "count of asics";
  P.ylabel g "bitcoin rate, $";

  let course x =
    let network_hashrate = network_hashrate +. (50000000000. *. x) in
    let difficulty = difficulty_for_hashrate network_hashrate in
    course bitcoin_reward difficulty 50000000000. 100. 3. in

  let amortizated_course x =
    let network_hashrate = network_hashrate +. (50000000000. *. x) in
    let difficulty = difficulty_for_hashrate network_hashrate in
    amortizated_course 1299. bitcoin_reward difficulty 50000000000. 0. 3. in

  P.color g green;
  P.fx g course 0. 100000.;
  P.color g red;
  P.fx g amortizated_course 0. 100000.;

  P.close g

let litecoin_videocards () =
  let g = P.init (*?offline:(offline 1) ~xsize:500. ~ysize:300.*) (device 1) in
  P.box g;
  P.box g ~x:[P.tics ~grid:true ()] ~y:[P.tics ~grid:true ()];
  P.xlabel g "watt-hour rate, rur";
  P.ylabel g "litecoin price, $";

  let difficulty = litecoin_difficulty in
  let course = course litecoin_reward difficulty in
  let amortizated_course hw_c = amortizated_course hw_c litecoin_reward difficulty in

  (* 7990 *)
  P.color g green;
  P.fx g (course 631000. 375.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_course 777. 631000. 375.) 0. 5.;

  (* 7970 *)
  P.color g green;
  P.fx g (course 750000. 55.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_course 391. 750000. 250.) 0. 5.

let videocards () =
  let g = P.init (*?offline:(offline 1) ~xsize:500. ~ysize:300.*) (device 1) in
  P.box g;
  P.box g ~x:[P.tics ~grid:true ()] ~y:[P.tics ~grid:true ()];
  P.xlabel g "watt-hour rate, rur";
  P.ylabel g "bitcoin price, $";

  let course = course bitcoin_reward difficulty in
  let amortizated_course hw_c = amortizated_course hw_c bitcoin_reward difficulty in

  (* 7990 *)
  P.color g green;
  P.fx g (course 1200000000. 375.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_course 777. 1200000000. 375.) 0. 5.;

  (* 7750 *)
  P.color g green;
  P.fx g (course 123000000. 55.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_course 93. 123000000. 55.) 0. 5.;

  P.close g

let lite_and_bit_comparison () =
  let g = P.init (*?offline:(offline 1) ~xsize:500. ~ysize:300.*) (device 1) in
  P.box g;
  P.box g ~x:[P.tics ~grid:true ()] ~y:[P.tics ~grid:true ()];
  P.xlabel g "watt-hour rate, rur";
  P.ylabel g "income per day, $";

  let bitcoin_income_per_day hashrate power power_rate =
    income_per_day market_rate bitcoin_reward difficulty hashrate power power_rate in
  let litecoin_income_per_day hashrate power power_rate =
    income_per_day litecoin_market_rate litecoin_reward litecoin_difficulty hashrate power power_rate in

  (* 7970 *)
  P.color g green;
  P.fx g (bitcoin_income_per_day 650000000. 250.) 0. 5.;
  P.color g red;
  P.fx g (litecoin_income_per_day 650000. 250.) 0. 5.;

  (* 7950 *)
  P.color g green;
  P.fx g (bitcoin_income_per_day 500000000. 200.) 0. 5.;
  P.color g red;
  P.fx g (litecoin_income_per_day 600000. 250.) 0. 5.;

  P.close g

(*let () = asics_income ()*)
(*let () = asics_course ()*)
(*let () = videocards ()*)
let () = lite_and_bit_comparison ()
(*let () = litecoin_videocards ()*)

