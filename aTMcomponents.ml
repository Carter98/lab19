(*
                Component Behaviors of an ATM Machine

The functions here represent the component behaviors that an ATM
machine can take, including: prompting for and acquiring from the
customer some information (choosing an action or entering an account
id or an amount); presenting information to the customer; dispensing
cash.

Implementation of these behaviors is likely to require some database
of accounts, each with an id number, a customer name, and a current
balance.
 *)

(* Customer account identifiers *)
type id = int

(* Possible actions that an ATM customer can perform *)
type action =
  | Balance           (* balance inquiry *)
  | Withdraw of int   (* withdraw an amount *)
  | Deposit of int    (* deposit an amount *)
  | Next              (* finish this customer and move on to the next one *)
  | Finished          (* shut down the ATM and exit entirely *)
;;

(*....................................................................
 Initializing database of accounts
*)

(* A specification of a customer name and initial balance for
   initializing the account database *)
type account_spec = {name : string; id : id; balance : int} ;;

(* initialize accts -- Establishes a database of accounts, each with a
   name, aribtrary id, and balance. The names and balances are
   initialized as per the `accts` provided. *)

module Account_set = Set.Make (struct
                                  type t = account_spec
                                  let compare acc1 acc2 = compare acc1.id acc2.id
                               end) ;;

let accounts = ref Account_set.empty ;;

let initialize (acc_list : account_spec list) : unit =
  accounts := (List.fold_left (fun s elt -> Account_set.add elt s) !accounts acc_list) ;;

(*....................................................................
 Acquiring information from the customer
*)

(* acquire_id () -- Requests from the ATM customer and returns an id
   (akin to entering one's ATM card), by prompting for an id number
   and reading an id from stdin. *)
let acquire_id () : id = read_int () ;;

(* acquire_amount () -- Requests from the ATM customer and returns an
   amount by prompting for an amount and reading an int from stdin. *)
let acquire_amount () : int = read_int () ;;

(* acquire_act () -- Requests from the user and returns an action to
   be performed, as a value of type action *)
let acquire_act : unit -> action = failwith "TODO" ;;

(*....................................................................
  Querying and updating the account database

  These functions all raise Not_found if there is no account with the
  given id.
 *)

(* get_balance id -- Returns the balance for the customer account with
   the given id. *)
let get_balance : id -> int = failwith "TODO" ;;

(* get_name id -- Returns the name associated with the customer
   account with the given id. *)
let get_name : id -> string = failwith "TODO" ;;

(* update_balance id amount -- Modifies the balance of the customer
   account with the given id,setting it to the given amount. *)
let update_balance : id -> int -> unit = failwith "TODO" ;;

(*....................................................................
  Presenting information and cash to the customer
 *)

(* present_message message -- Presents to the customer (on stdout) the
   given message followed by a newline. *)
let present_message : string -> unit = failwith "TODO" ;;

(* deliver_cash amount -- Dispenses the given amount of cash to the
   customer (really just prints to stdout a message to that
   effect). *)
let deliver_cash : int -> unit = failwith "TODO" ;;
