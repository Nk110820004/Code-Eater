import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:app_dev/models/people.dart';
import 'package:flutter/cupertino.dart';
import 'cart_item.dart';

class Org extends ChangeNotifier {
  final List<Person> serv = [
    Person(name: "hemnaat",
      description: "Good in videography and has over 100k follower base",
      imagePath: "lib/images/Digital_Marketing/Digital Marketing.png",
      price: 5000.00,
      category: PromoCategories.Digital_Marketing,
      availableAddons: [
        Addon(name: "cinematic", price: 100.00),
        Addon(name: "grand", price: 10000.00),
        Addon(name: "repeatations", price: 100.00),
      ],
    ),
    Person(
      name: "sneha",
      description: "Content strategist with viral Instagram reels",
      imagePath: "lib/images/Digital_marketing/ChatGPT Image Apr 11, 2025, 05_00_20 PM.png",
      price: 4000.00,
      category: PromoCategories.Digital_Marketing,
      availableAddons: [
        Addon(name: "SEO boost", price: 500.00),
        Addon(name: "ad copy", price: 200.00),
        Addon(name: "thumbnail design", price: 150.00),
      ],
    ),
    Person(
      name: "arjun",
      description: "Performance marketer with expertise in Meta ads",
      imagePath: "images/Digital_marketing/woman for a cover photo who does vlogs.png",
      price: 6000.00,
      category: PromoCategories.Digital_Marketing,
      availableAddons: [
        Addon(name: "ad analytics", price: 400.00),
        Addon(name: "funnel setup", price: 1000.00),
      ],
    ),
    Person(
      name: "isha",
      description: "YouTube growth expert and content planner",
      imagePath: "images/Traditional_marketing/one person as a cover photo.png",
      price: 5500.00,
      category: PromoCategories.Digital_Marketing,
      availableAddons: [
        Addon(name: "channel audit", price: 300.00),
        Addon(name: "video scripts", price: 250.00),
      ],
    ),
    Person(
      name: "karan",
      description: "Expert in influencer and affiliate campaigns",
      imagePath: "",
      price: 7000.00,
      category: PromoCategories.Digital_Marketing,
      availableAddons: [
        Addon(name: "influencer brief", price: 350.00),
        Addon(name: "tracking system", price: 600.00),
      ],
    ),
    //traditional marketing
    Person(
      name: "anjali",
      description: "Skilled in newspaper and billboard campaigns",
      imagePath: "",
      price: 3000.00,
      category: PromoCategories.Traditional_Marketing,
      availableAddons: [
        Addon(name: "print boost", price: 500.00),
        Addon(name: "extra coverage", price: 1000.00),
        Addon(name: "flyers", price: 200.00),
      ],
    ),
    Person(
      name: "dev",
      description: "Expert in local TV and radio promotions",
      imagePath: "",
      price: 4000.00,
      category: PromoCategories.Traditional_Marketing,
      availableAddons: [
        Addon(name: "voiceover", price: 300.00),
        Addon(name: "broadcast boost", price: 700.00),
      ],
    ),
    Person(
      name: "kavita",
      description: "Poster and hoarding campaign expert",
      imagePath: "",
      price: 2800.00,
      category: PromoCategories.Traditional_Marketing,
      availableAddons: [
        Addon(name: "design support", price: 200.00),
        Addon(name: "printing service", price: 500.00),
      ],
    ),
    Person(
      name: "sathish",
      description: "Regional newspaper outreach specialist",
      imagePath: "",
      price: 3500.00,
      category: PromoCategories.Traditional_Marketing,
      availableAddons: [
        Addon(name: "editorial write-up", price: 1000.00),
        Addon(name: "translation", price: 300.00),
      ],
    ),
    Person(
      name: "riya",
      description: "Offline brand promotions and print ads",
      imagePath: "",
      price: 3700.00,
      category: PromoCategories.Traditional_Marketing,
      availableAddons: [
        Addon(name: "color ad", price: 250.00),
        Addon(name: "front page placement", price: 900.00),
      ],
    ),
    //Direct marketing
    Person(
      name: "rohit",
      description: "Expert in door-to-door and pamphlet distribution",
      imagePath: "",
      price: 2500.00,
      category: PromoCategories.Direct_Marketing,
      availableAddons: [
        Addon(name: "custom flyers", price: 150.00),
        Addon(name: "area targeting", price: 500.00),
        Addon(name: "follow-ups", price: 300.00),
      ],
    ),
    Person(
      name: "neha",
      description: "Direct mail and SMS campaign specialist",
      imagePath: "",
      price: 2800.00,
      category: PromoCategories.Direct_Marketing,
      availableAddons: [
        Addon(name: "sms pack", price: 400.00),
        Addon(name: "email templates", price: 350.00),
      ],
    ),
    Person(
      name: "vinay",
      description: "Cold calling expert for local lead generation",
      imagePath: "",
      price: 3000.00,
      category: PromoCategories.Direct_Marketing,
      availableAddons: [
        Addon(name: "script writing", price: 200.00),
        Addon(name: "telecaller", price: 1000.00),
      ],
    ),
    Person(
      name: "juhi",
      description: "Pamphlet design and house delivery campaigns",
      imagePath: "",
      price: 2700.00,
      category: PromoCategories.Direct_Marketing,
      availableAddons: [
        Addon(name: "color print", price: 250.00),
        Addon(name: "multi-area drop", price: 500.00),
      ],
    ),
    Person(
      name: "rajeev",
      description: "WhatsApp and Email-based direct marketing expert",
      imagePath: "",
      price: 2900.00,
      category: PromoCategories.Direct_Marketing,
      availableAddons: [
        Addon(name: "bulk messaging", price: 600.00),
        Addon(name: "auto-responder", price: 400.00),
      ],
    ),
    // Experiential marketing
    Person(
      name: "kiara",
      description: "Creates memorable event-based brand experiences",
      imagePath: "",
      price: 8000.00,
      category: PromoCategories.Experiential_Marketing,
      availableAddons: [
        Addon(name: "venue setup", price: 3000.00),
        Addon(name: "live coverage", price: 1500.00),
        Addon(name: "celebrity guest", price: 5000.00),
      ],
    ),
    Person(
      name: "amit",
      description: "Immersive marketing with VR & AR demos",
      imagePath: "",
      price: 10000.00,
      category: PromoCategories.Experiential_Marketing,
      availableAddons: [
        Addon(name: "virtual stage", price: 2000.00),
        Addon(name: "custom headset", price: 3000.00),
      ],
    ),
    Person(
      name: "laila",
      description: "Creates themed pop-up events and brand activations",
      imagePath: "",
      price: 9000.00,
      category: PromoCategories.Experiential_Marketing,
      availableAddons: [
        Addon(name: "popup booth", price: 2500.00),
        Addon(name: "branding materials", price: 1500.00),
      ],
    ),
    Person(
      name: "mohan",
      description: "Festival and concert brand engagement specialist",
      imagePath: "",
      price: 9500.00,
      category: PromoCategories.Experiential_Marketing,
      availableAddons: [
        Addon(name: "stage banners", price: 1000.00),
        Addon(name: "MC announcement", price: 500.00),
      ],
    ),
    Person(
      name: "diya",
      description: "Product sampling and interactive demo campaigns",
      imagePath: "",
      price: 8700.00,
      category: PromoCategories.Experiential_Marketing,
      availableAddons: [
        Addon(name: "sample packs", price: 600.00),
        Addon(name: "demo staff", price: 800.00),
      ],
    ),
    // B2B Marketing
    Person(
      name: "naveen",
      description: "Expert in corporate outreach and networking",
      imagePath: "",
      price: 7000.00,
      category: PromoCategories.B2B_Marketing,
      availableAddons: [
        Addon(name: "email funnel", price: 600.00),
        Addon(name: "lead magnet", price: 800.00),
      ],
    ),
    Person(
      name: "shruti",
      description: "LinkedIn campaigns and CRM integration specialist",
      imagePath: "",
      price: 7200.00,
      category: PromoCategories.B2B_Marketing,
      availableAddons: [
        Addon(name: "automation setup", price: 1000.00),
        Addon(name: "CRM dashboard", price: 1500.00),
      ],
    ),
    Person(
      name: "sanjay",
      description: "Expert in trade shows and B2B conventions",
      imagePath: "",
      price: 8000.00,
      category: PromoCategories.B2B_Marketing,
      availableAddons: [
        Addon(name: "event collateral", price: 700.00),
        Addon(name: "booth design", price: 1200.00),
      ],
    ),
    Person(
      name: "reena",
      description: "Partnership and business alliance creator",
      imagePath: "",
      price: 7600.00,
      category: PromoCategories.B2B_Marketing,
      availableAddons: [
        Addon(name: "partnership proposal", price: 500.00),
        Addon(name: "collab pitch deck", price: 900.00),
      ],
    ),
    Person(
      name: "yusuf",
      description: "Cold outreach and enterprise sales funnel expert",
      imagePath: "",
      price: 7800.00,
      category: PromoCategories.B2B_Marketing,
      availableAddons: [
        Addon(name: "B2B calling script", price: 300.00),
        Addon(name: "email sequences", price: 600.00),
      ],
    ),
    //B2C marketing
    Person(
      name: "meera",
      description: "Expert in online retail and customer outreach",
      imagePath: "",
      price: 5000.00,
      category: PromoCategories.B2C_Marketing,
      availableAddons: [
        Addon(name: "sales copy", price: 400.00),
        Addon(name: "coupon design", price: 300.00),
      ],
    ),
    Person(
      name: "tanya",
      description: "Instagram and Facebook shopper funnel strategist",
      imagePath: "",
      price: 4800.00,
      category: PromoCategories.B2C_Marketing,
      availableAddons: [
        Addon(name: "carousel ad", price: 250.00),
        Addon(name: "highlight set", price: 200.00),
      ],
    ),
    Person(
      name: "vikram",
      description: "Loyalty programs and app installs specialist",
      imagePath: "",
      price: 5300.00,
      category: PromoCategories.B2C_Marketing,
      availableAddons: [
        Addon(name: "reward system", price: 800.00),
        Addon(name: "push notifications", price: 500.00),
      ],
    ),
    Person(
      name: "simran",
      description: "Festive offer campaign and WhatsApp deals expert",
      imagePath: "",
      price: 5200.00,
      category: PromoCategories.B2C_Marketing,
      availableAddons: [
        Addon(name: "festival pack", price: 700.00),
        Addon(name: "status promo", price: 300.00),
      ],
    ),
    Person(
      name: "akash",
      description: "E-commerce sales and influencer tie-up specialist",
      imagePath: "",
      price: 5400.00,
      category: PromoCategories.B2C_Marketing,
      availableAddons: [
        Addon(name: "product unboxing", price: 600.00),
        Addon(name: "giveaway", price: 500.00),
      ],
    ),
    //Niche Marketing
    Person(
      name: "tarun",
      description: "Expert in micro-market campaigns and precision ads",
      imagePath: "",
      price: 6000.00,
      category: PromoCategories.Niche_Marketing,
      availableAddons: [
        Addon(name: "hyperlocal reach", price: 400.00),
        Addon(name: "niche branding kit", price: 700.00),
      ],
    ),
    Person(
      name: "sona",
      description: "Custom marketing for specific cultural groups",
      imagePath: "",
      price: 6200.00,
      category: PromoCategories.Niche_Marketing,
      availableAddons: [
        Addon(name: "language variant", price: 300.00),
        Addon(name: "cultural design", price: 500.00),
      ],
    ),
    Person(
      name: "raghav",
      description: "Targeted ads for gamer and tech communities",
      imagePath: "",
      price: 6500.00,
      category: PromoCategories.Niche_Marketing,
      availableAddons: [
        Addon(name: "Discord promo", price: 400.00),
        Addon(name: "Twitch overlay", price: 350.00),
      ],
    ),
    Person(
      name: "maya",
      description: "Marketing for sustainable and eco brands",
      imagePath: "",
      price: 6300.00,
      category: PromoCategories.Niche_Marketing,
      availableAddons: [
        Addon(name: "green branding", price: 600.00),
        Addon(name: "eco packaging visuals", price: 500.00),
      ],
    ),
    Person(
      name: "devika",
      description: "Luxury and high-ticket product marketing expert",
      imagePath: "",
      price: 6800.00,
      category: PromoCategories.Niche_Marketing,
      availableAddons: [
        Addon(name: "exclusive launch", price: 1000.00),
        Addon(name: "premium design", price: 800.00),
      ],
    ),
  ];

  /*  Getters  */
  List<Person> get lance => lance;
  List<CartItem> get cart => _cart;
  /*  operations */
  // user cart
  final List<CartItem> _cart = [];

  // add to cart
  void addToCart(Person person, List<Addon> selectedAddons) {
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      bool isSamePerson = item.person == person;
      bool isSameAddon = ListEquality().equals(
          item.selectedAddons, selectedAddons);
      return isSamePerson && isSameAddon;
    });
    if (cartItem != null) {
      cartItem.quantity++;
    }
    else {
      _cart.add(CartItem(person: person, selectedAddons: selectedAddons),);
    }
  }

  //  remove from cart
  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);
    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }

    }
    notifyListeners();
  }

  //  get total price
  double gettotalPrice() {
    double total = 0;
    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.person.price;
      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }
      total += itemTotal * cartItem.quantity;
    }

    return total;
  }

  //  get total number of items in cart
  int gettotalItemsCount() {
    int totalItemCount = 0;
    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }
    return totalItemCount;
  }


  //  clear cart
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
  /*  Helpers
  * generate a receipt
  *  format double value into money
  * format list of addons into a string summary*/


