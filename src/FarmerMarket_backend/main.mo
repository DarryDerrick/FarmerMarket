module FarmerMarket {
import Time "mo:base/Time";
  // Define Farmer data structure
  type Farmer = {
    id : Text;
    name : Text;
    produce : Text;
    quantity : Nat;
    price : Nat;
    verified : Bool;
  };

  // Define Listing data structure
  type Listing = {
    farmerId : Text;
    produce : Text;
    quantity : Nat;
    price : Nat;
    active : Bool;
  };

  // Define Order data structure
  type Order = {
    orderId : Text;
    farmerId : Text;
    buyerId : Text;
    produce : Text;
    quantity : Nat;
    price : Nat;
    status : Text; // Status: "pending", "completed", "cancelled"
    timestamp : Time.Time;
  };

  // Define Farmer Market state
  type State = {
    farmers : HashMap.HashMap<Text, Farmer>;
    listings : HashMap.HashMap<Text, Listing>;
    orders : HashMap.HashMap<Text, Order>;
  };

  // Initialize state
  var state : State = {
    farmers = HashMap.empty();
    listings = HashMap.empty();
    orders = HashMap.empty();
  };

  // Function to register a new farmer
  public func registerFarmer(id : Text, name : Text, produce : Text, quantity : Nat, price : Nat) : async () {
    let farmer : Farmer = {
      id = id;
      name = name;
      produce = produce;
      quantity = quantity;
      price = price;
      verified = false;
    };
    state.farmers.put(id, farmer);
  };

  // Function to list produce by a farmer
  public func listProduce(farmerId : Text, produce : Text, quantity : Nat, price : Nat) : async () {
  assert(state.farmers.containsKey(farmerId), "Farmer not registered");

  let listing : Listing = {
    farmerId = farmerId;
    produce = produce;
    quantity = quantity;
    price = price;
    active = true;
  };

  state.listings.put(produce, listing);
};


  // Function to place an order
  public func placeOrder(orderId : Text, farmerId : Text, buyerId : Text, produce : Text, quantity : Nat, price : Nat) : async () {
    assert (state.farmers.containsKey(farmerId), "Farmer not registered");
    assert (state.listings.containsKey(produce), "Produce not listed");
    let listing = state.listings.get(produce);
    assert (listing.active, "Produce not available");
    assert (listing.quantity >= quantity, "Insufficient quantity available");
    let order : Order = {
      orderId = orderId;
      farmerId = farmerId;
      buyerId = buyerId;
      produce = produce;
      quantity = quantity;
      price = price;
      status = "pending";
      timestamp = Time.now();
    };
    state.orders.put(orderId, order);
  };

  // Function to mark an order as completed
  public func completeOrder(orderId : Text) : async () {
    assert (state.orders.containsKey(orderId), "Order not found");
    let order = state.orders.get(orderId);
    assert (order.status == "pending", "Order already completed or cancelled");
    state.orders.put(orderId, { order with status = "completed" });
    // Adjust quantity of produce listed by farmer
    let listing = state.listings.get(order.produce);
    let newQuantity = listing.quantity - order.quantity;
    state.listings.put(order.produce, { listing with quantity = newQuantity });
  };

  // Function to cancel an order
  public func cancelOrder(orderId : Text) : async () {
    assert (state.orders.containsKey(orderId), "Order not found");
    let order = state.orders.get(orderId);
    assert (order.status == "pending", "Order already completed or cancelled");
    state.orders.put(orderId, { order with status = "cancelled" });
  };

  // Function to verify farmer
  public func verifyFarmer(farmerId : Text) : async () {
    assert (state.farmers.containsKey(farmerId), "Farmer not registered");
    let farmer = state.farmers.get(farmerId);
    state.farmers.put(farmerId, { farmer with verified = true });
  };

  // Function to get all active listings
  public query func getActiveListings() : async [Listing] {
    let allListings = state.listings.entries();
    let activeListings = Array.filter((_, listing) :=  listing.active, allListings);
    return Array.map((_, listing) :=  listing._2, activeListings);
  };

  // Function to get all orders for a farmer
  public query func getFarmerOrders(farmerId : Text) : async [Order] {
    let allOrders = state.orders.entries();
    let farmerOrders = Array.filter((_, order) :=  order.farmerId == farmerId, allOrders);
    return Array.map((_, order) :=  order._2, farmerOrders);
  };

  // Function to get all orders for a buyer
  public query func getBuyerOrders(buyerId : Text) : async [Order] {
    let allOrders = state.orders.entries();
    let buyerOrders = Array.filter((_, order) :=  order.buyerId == buyerId, allOrders);
    return Array.map((_, order) :=  order._2, buyerOrders);
  };
};

