open Parse_args
module P = Gnuplot
open Common

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

let litecoin_course () =
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
  P.fx g (course 750000. 250.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_course 391. 750000. 250.) 0. 5.;

  (* my T400 :) *)
  (*P.color g green;
  P.fx g (course 10420. 30.) 0. 5.;
  P.color g red;
  P.fx g (amortizated_course 230. 10420. 30.) 0. 5.*)

  P.close g

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
(*let () = litecoin_course ()*)

