# Map Legend

## How things appear on screen

### Points of interest

The standard Garmin icons are used throughout. Shops appear as a shopping bag, food and drink with a knife and fork, supermarkets as a shopping trolley, etc.

This map style varies from other similar ones in a couple of ways.  One is that often several OSM tags are processed to decide what category to show something as.  Another is that the OSM tags are used to provide more detail when you hover over the icon, or search for it on the Garmin menus. For example, a fuel station ("amenity=fuel" in OSM) will be shown with a petrol pump icon as normal, but it'll also have "fuel" qnd the brand in brackets after the name.

For many features, lots of different (but related) OSM tags are shown with the same icon.  For example, several different types of shop that sell a variety of goods are shown as "general" shops.  "shop=general" is one example, but "shop=catalogue" is another, and an Argos will appear on screen and in the search menus as "Argos (catalogue)".

### Other features

Things like roads, tracks and paths appear as you would expect them to on a Garmin device, but with extra information for rights of way and quality control appended to the name (see below for more details).

## How things can be searched for.

Among the search options on the Garmin menus are searches for different POI types.

The top level POI search options are:

> Food and Drink, Cities, Transportation, All POIs, Shopping, Fuel Services, Lodging, Entertainment, Recreation, Attractions, Auto Services, Community, Hospitals, Geographic points, Others

An attempt has been made to distribute OSM POIs logically among these menus.

### Searching for the Garmin menu used for an OSM tag

To find out what Garmin menu an OSM feature has been mapped to, go, [here](https://taginfo.openstreetmap.org/projects/someoneelse_mkgmap_ajt03#tags) and search for the OSM tag or value you are interested in.

### Details of which OSM tags appear on which Garmin menu

#### Food and Drink

All the items here appear on-screen as a knife and fork on a blue square background.

Garmin's menus here are very American (you can have "International", but you can't get a curry).  Fast food and "proper restaurants" are all lumped together.  I've tried to make the best use of the catagories as I can, which results in some odd mappings:

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Food and Drink</td>
<td> All Categories </td>
<td> Everything below </td>
<td>  </td>
</tr>
<tr>
<td> </td>
<td> American </td>
<td> Burger-led fast food </td>
<td> (amenity=fast_food or amenity=restaurant) and (cuisine=burger or cuisine=american or cuisine=diner) </td>
</tr>
<tr>
<td> </td>
<td> Asian </td>
<td> Not used as not uniquely searchable </td>
<td> n/a </td>
</tr>
<tr>
<td> </td>
<td> Barbeque </td>
<td> Chicken-led fast food </td>
<td> amenity=fast_food and (cuisine=chicken or cuisine=fried_chicken) </td>
</tr>
<tr>
<td> </td>
<td> Chinese </td>
<td> Chinese or similar fast food </td>
<td> amenity=fast_food and cuisine one of chinese, thai, asian, japanese, sushi, korean, ramen, noodle, malaysian, indonesian, cantonese, oriental </td>
</tr>
<tr>
<td> </td>
<td> Deli or Bakery </td>
<td> Bakery </td>
<td> shop=bakery </td>
</tr>
<tr>
<td> </td>
<td> International </td>
<td> Kebab-led fast food </td>
<td> amenity=fast_food and (cuisine=kebab or cuisine=turkish) </td>
</tr>
<tr>
<td> </td>
<td> Fast Food </td>
<td> Pie-led fast food </td>
<td> amenity=fast_food and cuisine=pasties, pasty, cornish_pasty, pie, pies </td>
</tr>
<tr>
<td> </td>
<td> Italian </td>
<td> Italian or similar Restaurant </td>
<td> amenity=restaurant and cuisine=italian, pizza, mediterranean </td>
</tr>
<tr>
<td> </td>
<td> Mexican </td>
<td> Curry-led fast food </td>
<td> amenity=fast_food and cuisine=indian, curry, nepalese, bangladeshi, pakistani, tandoori, afghan, sri_lankan, punjabi </td>
</tr>
<tr>
<td> </td>
<td> Pizza </td>
<td> Italian or similar fast food </td>
<td> amenity=fast_food and cuisine=italian, pasta or pizza </td>
</tr>
<tr>
<td> </td>
<td> Seafood </td>
<td> Fish and Chips led fast food </td>
<td> amenity=fast_food and cuisine=fish_and_chips, fish, chines;fish_and_chips </td>
</tr>
<tr>
<td> </td>
<td> Steak or Grill </td>
<td> Steak Restaurant </td>
<td> amenity=restaurant and cuisine=steak_house, grill, brazilian, argentinian </td>
</tr>
<tr>
<td> </td>
<td> Bagel or Donut </td>
<td> Ice Cream Parlours </td>
<td> Various amenity, shop and cuisine=ice_cream tags </td>
</tr>
<tr>
<td> </td>
<td> Cafe or Diner </td>
<td> Cafes and coffee shops </td>
<td> amenity=fast_food and (cuisine=coffee or cuisine=sandwich) </td>
</tr>
<tr>
<td> </td>
<td> French </td>
<td> Indian Restaurant </td>
<td> amenity=restaurant and cuisine=indian </td>
</tr>
<tr>
<td> </td>
<td> German </td>
<td> Chinese or similar Restaurant </td>
<td> amenity=restaurant and cuisine=chinese, thai, asian, japanese, vietnamese, korean, sushi </td>
</tr>
<tr>
<td> </td>
<td> British Isles </td>
<td> Pubs and bars </td>
<td> amenity=pub or amenity=bar </td>
</tr>
<tr>
<td> </td>
<td> n/a </td>
<td> Any other fast food or restaurant </td>
<td> amenity=fast_food or amenity=restaurant with a cuisine not handled above</td>
</tr>
</table>

#### Cities

Most OSM places (not just cities) appear here.  They are shown as a dot.  Rare places ("cape") are consolidated into e.g. "locality".

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Cities </td>
<td> n/a </td>
<td> Most "place" values </td>
<td> place=city, town, suburb, village, hamlet, locality, cape</td>
</tr>
</table>

#### Transportation

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Appears as** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Transportation </td>
<td> All Categories </td>
<td> Everything below </td>
<td> </td>
<td> </td>
</tr>
<tr>
<td>  </td>
<td> Auto Rental </td>
<td> Car Rental etc. </td>
<td> Red car with a black key </td>
<td> amenity=car_rental, van_rental </td>
</tr>
<tr>
<td>  </td>
<td> Air Transportation </td>
<td> Public transportation airports </td>
<td> Blue aircraft on a grey square</td>
<td> aeroway=aerodrome, heliport with iata tag; terminal </td>
</tr>
<tr>
<td>  </td>
<td> Ground Transportation </td>
<td> Railway stations, bus stations, rental bikes </td>
<td> A large bus</td>
<td> railway=station, amenity=bus_station, ferry_terminal, bicycle_rental </td>
</tr>
<tr>
<td>  </td>
<td> Transit Service </td>
<td> Tram stops, bus stops </td>
<td> Small dot </td>
<td> railway=tram_stop, highway=bus_stop, amenity=taxi </td>
</tr>
</table>

#### Shopping

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Appears as** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Shopping </td>
<td> All Categories </td>
<td> Everything below </td>
<td> </td>
<td> </td>
</tr>
<tr>
<td> Shopping </td>
<td> Department </td>
<td> Department stores </td>
<td> Brown shopping bag</td>
<td> shop=department_store</td>
</tr>
<tr>
<td> Shopping </td>
<td> Grocery </td>
<td> Supermarkets </td>
<td> Shopping trolley on brown square </td>
<td> shop=supermarket</td>
</tr>
<tr>
<td> Shopping </td>
<td> General Merchandise </td>
<td> Other shops taking a variety of goods </td>
<td> Brown shopping bag </td>
<td> shop=variety_store, outpost, general, catalogue</td>
</tr>
<tr>
<td> Shopping </td>
<td> Shopping Center </td>
<td> Various shop groups </td>
<td> Shopping trolley on brown square </td>
<td> amenity=marketplace, market, food_court</td>
</tr>
<tr>
<td> Shopping </td>
<td> Pharmacy or Chemist </td>
<td> Parmacies, chemists etc. </td>
<td> RX on white square </td>
<td> amenity=pharmacy, spa, healthcare=pharmacy, shop=beauty, chemist, cosmetics, leisure=spa </td>
</tr>
<tr>
<td> Shopping </td>
<td> Apparel </td>
<td> Various clothes shops </td>
<td> Brown shopping bag </td>
<td> shop=clothes, shoes, etc.; craft=dressmaker, tailor </td>
</tr>
<tr>
<td> Shopping </td>
<td> House and Garden </td>
<td> Garden centres </td>
<td> Small dot</td>
<td> shop=garden_centre, plant_nursery, nursery, lawn_mower, etc. </td>
</tr>
<tr>
<td> Shopping </td>
<td> Home Furnishings </td>
<td> DIY and hardware shops, also related trades. </td>
<td> Small dot</td>
<td> craft=plumber (and many others), shop=hardware, furniture, doityourself, homeware, etc. </td>
</tr>
<tr>
<td> Shopping </td>
<td> Specialty Retail </td>
<td> Shops that don't fit other categories </td>
<td> Small dot</td>
<td> shop=hairdresser, butcher (and many, many others) </td>
</tr>
<tr>
<td> Shopping </td>
<td> Computer or Software </td>
<td> Computer and mobile phone shops </td>
<td> Small dot</td>
<td> shop=mobile_phone, computer </td>
</tr>
<tr>
<td> Shopping </td>
<td> Convenience </td>
<td> Local convenience stores </td>
<td> Small dot </td>
<td> shop=convenience, kiosk, newsagent </td>
</tr>
<tr>
<td> Shopping </td>
<td> Florist </td>
<td> Florists </td>
<td> Small dot</td>
<td> shop=florist </td>
</tr>
<tr>
<td> Shopping </td>
<td> Gift/Antiques/Art </td>
<td> Various gift etc. shops </td>
<td> Small dot </td>
<td> shop=gift, art, antiques, craft, bag among others </td>
</tr>
<tr>
<td> Shopping </td>
<td> Record/CD/Video </td>
<td> Record,CD,Video and Music shops </td>
<td> Small dot </td>
<td> shop=music, records </td>
</tr>
<tr>
<td> Shopping </td>
<td> Sporting Goods </td>
<td> Various sport shops </td>
<td> Small dot </td>
<td> shop=sports, fishing, etc. </td>
</tr>
<tr>
<td> Shopping </td>
<td> Wine and Liquor </td>
<td> Shops specialising in alcohol (but not wineries) </td>
<td> Small dot</td>
<td> shop=alcohol, wine etc. </td>
</tr>
<tr>
<td> Shopping </td>
<td> Book Store </td>
<td> Book shops </td>
<td> Small dot</td>
<td> shop=books </td>
</tr>
</table>


#### Fuel Services

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Appears as** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Fuel Services </td>
<td> </td>
<td> Fuel stations (petrol and diesel, and electric) </td>
<td> Petrol pump </td>
<td> amenity=fuel, amenity=charging_station </td>
</tr>
</table>

#### Lodging

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Appears as** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Lodging </td>
<td> All catgories</td>
<td> Everything below </td>
<td>  </td>
<td>  </td>
</tr>
<tr>
<td> Lodging </td>
<td> Hotel or Motel</td>
<td> Hotels </td>
<td> White bed on green square </td>
<td> tourism=hotel, motel </td>
</tr>
<tr>
<td> Lodging </td>
<td> Bed and Breakfast or</td>
<td> Guest houses, tourist apartments, etc. </td>
<td> White bed on green square </td>
<td> tourism=guest_house, apartment, holiday_village </td>
</tr>
<tr>
<td> Lodging </td>
<td> Resort</td>
<td> Holiday resorts </td>
<td> Green tent </td>
<td> tourism=resort, spa_resort </td>
</tr>
<tr>
<td> Lodging </td>
<td> Campground </td>
<td> Camp sites, hostels, caravan sites </td>
<td> Green tent </td>
<td> tourism=camp_site, hostel, caravan_site </td>
</tr>
<tr>
<td> Lodging </td>
<td> Other </td>
<td> Nothing in this category </td>
<td> White bed on green square </td>
<td> n/a </td>
</tr>
</table>

#### Entertainment

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Appears as** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Entertainment </td>
<td> All catgories</td>
<td> Everything below </td>
<td>  </td>
<td>  </td>
</tr>
<tr>
<td> Entertainment </td>
<td> Live Theater</td>
<td> Theatres, arts centres </td>
<td> Comedy and tragedy masks </td>
<td> amenity=theatre, arts_centre </td>
</tr>
<tr>
<td> Entertainment </td>
<td> Bar or Nightclub </td>
<td> Nightclubs </td>
<td> Beer mug </td>
<td> amenity=nightclub </td>
</tr>
<tr>
<td> Entertainment </td>
<td> Movie Theater </td>
<td> Cinemas </td>
<td> Projector </td>
<td> amenity=cinema </td>
</tr>
<tr>
<td> Entertainment </td>
<td> Casino </td>
<td> Casinos </td>
<td> Characteristic but unknown </td>
<td> amenity=casino </td>
</tr>
</table>

#### Recreation

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Appears as** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Recreation </td>
<td> All catgories</td>
<td> Everything below </td>
<td>  </td>
<td>  </td>
</tr>
<tr>
<td> Recreation </td>
<td> Golf Course</td>
<td> Golf courses </td>
<td> Golf flag </td>
<td> leisure=golf_course </td>
</tr>
<tr>
<td> Recreation </td>
<td> Skiing Center or Reso</td>
<td> Skiing </td>
<td> White skier on blue square </td>
<td> sport=skiing </td>
</tr>
<tr>
<td> Recreation </td>
<td> Bowling Center</td>
<td> Bowling and bowls </td>
<td> Ball and skittle </td>
<td> leisure=bowling_alley, sport=bowls, 10pin, 9pin </td>
</tr>
<tr>
<td> Recreation </td>
<td> Ice Skating</td>
<td> Ice skating </td>
<td> Ice skate on blue square </td>
<td> leisure=ice_rink, sport=ice_skating </td>
</tr>
<tr>
<td> Recreation </td>
<td> Swimming Pool</td>
<td> Swimming pools </td>
<td> Swimmer </td>
<td> leisure=swimming_pool, sport=swimming </td>
</tr>
<tr>
<td> Recreation </td>
<td> Sports or Fitness Cen</td>
<td> Leisure centres etc. </td>
<td> Exercise bike on a green square </td>
<td> leisure=sports_centre, amenity=leisure_centre, dojo, gym, sport=fitness_centre </td>
</tr>
<tr>
<td> Recreation </td>
<td> Public Sport Airport</td>
<td> Gliding clubs and general aviation </td>
<td> Blue aircraft on a grey square </td>
<td> amenity=aerodrome, heliport without 'iata' tag and non-military </td>
</tr>
<tr>
<td> Attractions </td>
<td> Amusement Park or T</td>
<td> Theme parks </td>
<td> Rollercoaster </td>
<td> tourism=theme_park </td>
</tr>
<tr>
<td> Recreation </td>
<td> Park or Garden</td>
<td> Parks and gardens (named) </td>
<td> Green tree </td>
<td> landuse=grass, meadow, recreation_ground, greenfield, flowerbed, leisure=park, garden, playground, outdoor_seating, common, fishing, recreation_ground, showground </td>
</tr>
<tr>
<td> Recreation </td>
<td> Arena or Track</td>
<td> Sports pitches tracks and stadia </td>
<td> Baseball </td>
<td> leisure=pitch, track, stadium, dog_park </td>
</tr>
</table>

#### Attractions

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Appears as** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Attractions </td>
<td> All catgories</td>
<td> Everything below </td>
<td>  </td>
<td>  </td>
</tr>
<tr>
<td> Attractions </td>
<td> Other</td>
<td> Nothing in this category </td>
<td> Green tree </td>
<td> n/a </td>
</tr>
<tr>
<td> Attractions </td>
<td> Amusement Park or T</td>
<td> Theme parks </td>
<td> Rollercoaster </td>
<td> tourism=theme_park </td>
</tr>
<tr>
<td> Attractions </td>
<td> Museum or Historical</td>
<td> Various historic features </td>
<td> tourism=museum, gallery, historic=memorial, wayside_cross, archaeological_site, ruins, wayside_shrine, monument, building, castle, tomb, manor, mine, mine_shaft </td>
<td> Museum </td>
<td> </td>
</tr>
<tr>
<td> Attractions </td>
<td> Landmark </td>
<td> Artworks, tourist railway stations, miiitary airports </td>
<td> Blue camera </td>
<td> tourism=artwork, railway=station, aeroway=aerodrome </td>
</tr>
<tr>
<td> Attractions </td>
<td> Park or Garden</td>
<td> Parks and gardens (named) </td>
<td> Green tree </td>
<td> landuse=grass, meadow, recreation_ground, greenfield, flowerbed, leisure=park, garden, playground, outdoor_seating, common, fishing, recreation_ground, showground </td>
</tr>
<tr>
<td> Attractions </td>
<td> Zoo or Aquarium </td>
<td> Zoos and aquariums </td>
<td> Elephant </td>
<td> tourism=zoo, aquarium </td>
</tr>
<tr>
<td> Attractions </td>
<td> Arena or Track</td>
<td> Sports pitches tracks and stadia </td>
<td> Baseball </td>
<td> leisure=pitch, track, stadium, dog_park </td>
</tr>
<tr>
<td> Attractions </td>
<td> Hall or Auditorium </td>
<td> Events venues, conference centres, exhibition centres, concert halls </td>
<td> Museum </td>
<td> amenity=events_venue, conference_centre, exhibition_centre, concert_hall, theatre:type=concert_hall, theatre=concert_hall </td>
</tr>
<tr>
<td> Attractions </td>
<td> Winery </td>
<td> Wineries </td>
<td> Wine glass </td>
<td> craft=winery </td>
</tr>
</table>

#### Auto Services

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Appears as** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Auto Services </td>
<td> All catgories</td>
<td> Everything below </td>
<td>  </td>
<td>  </td>
</tr>
<tr>
<td> Auto Services </td>
<td> Auto Rental </td>
<td> Car Rental etc. </td>
<td> Red car with a black key </td>
<td> amenity=car_rental, van_rental </td>
</tr>
<tr>
<td> Auto Services </td>
<td> Auto Repair </td>
<td> Car and other vehicle repair </td>
<td> Car on jack </td>
<td> shop=car_repair, motorcycle_repair, truck_repair etc. </td>
</tr>
<tr>
<td> Auto Services </td>
<td> Dealer or Auto Parts </td>
<td> Vehicle dealers and parts suppliers </td>
<td> Red car </td>
<td> shop=car, car_parts, tyres, motorcyele, agrarian (machinery etc.), caravan </td>
</tr>
<tr>
<td> Auto Services </td>
<td> Parking </td>
<td> Car parking </td>
<td> Red P on white square </td>
<td> amenity=parking </td>
</tr>
<tr>
<td> Auto Services </td>
<td> Rest Area or Tourism I </td>
<td> Toilets (shown with a suffix indicating pay or free, male or female etc.)</td>
<td> Toilets on blue square </td>
<td> amenity=toilets </td>
</tr>
<tr>
<td> Auto Services </td>
<td> Automobile Club </td>
<td> Car rental, car sharing </td>
<td> Red car </td>
<td> amenity=car_rental, car_sharing etc. </td>
</tr>
<tr>
<td> Auto Services </td>
<td> Car Wash </td>
<td> Car wash </td>
<td> Red car </td>
<td> amenity=car_wash </td>
</tr>
</table>

#### Community

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Appears as** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Community </td>
<td> All catgories</td>
<td> Everything below </td>
<td>  </td>
<td>  </td>
</tr>
<tr>
<td> Community </td>
<td> Library </td>
<td> Libraries and book exchanges </td>
<td> Book </td>
<td> amenity=library, book_exchange, public_bookcase </td>
</tr>
<tr>
<td> Community </td>
<td> School </td>
<td> Schools and other educational institutions </td>
<td> American school bus </td>
<td> amenity=school, kindergarten, college, university </td>
</tr>
<tr>
<td> Community </td>
<td> Place of Worship </td>
<td> Places of worship </td>
<td> Dot </td>
<td> amenity=place_of_worship </td>
</tr>
<tr>
<td> Community </td>
<td> Police Station </td>
<td> Police Stations </td>
<td> American police badge </td>
<td> amenity=police </td>
</tr>
<tr>
<td> Community </td>
<td> City Hall </td>
<td> Nothing in this category </td>
<td> Blue building with flag </td>
<td> n/a </td>
</tr>
<tr>
<td> Community </td>
<td> Court House </td>
<td> Courthouses </td>
<td> Red building </td>
<td> amenity=courthouse </td>
</tr>
<tr>
<td> Community </td>
<td> Community Center </td>
<td> Various community and social facilities </td>
<td> Red building </td>
<td> amenity=community_centre, social_facility, childcare, nursing_home, public_bath etc. </td>
</tr>
<tr>
<td> Community </td>
<td> Border Crossing </td>
<td> Border controls and customs areas </td>
<td> Red no entry sign </td>
<td> barrier=border_control, government=customs </td>
</tr>
<tr>
<td> Community </td>
<td> Government Office </td>
<td> Various government and related offices </td>
<td> Dot </td>
<td> office=government, administrative, forestry, register_office </td>
</tr>
<tr>
<td> Community </td>
<td> Fire Department </td>
<td> Fire station </td>
<td> Dot </td>
<td> amenity=fire_station </td>
</tr>
<tr>
<td> Community </td>
<td> Post Office </td>
<td> Post boxes and post offices </td>
<td> Blue letter with stamp </td>
<td> amenity=post_box, post_office </td>
</tr>
<tr>
<td> Community </td>
<td> Bank or ATM </td>
<td> Banks, ATMs and building societies, currency exchange </td>
<td> Dollar bill </td>
<td> amenity=bank, atm, bureau_de_change </td>
</tr>
<tr>
<td> Community </td>
<td> Utility </td>
<td> Recycling bins and recycling centres </td>
<td> Dot </td>
<td> amenity=recycling </td>
</tr>
</table>

#### Hospitals

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Appears as** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Hospitals </td>
<td> </td>
<td> Medical services </td>
<td> Blue cross on white square </td>
<td> amenity=hospital, clinic, doctors, dentist etc. </td>
</tr>
</table>

#### Geographic Points

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Appears as** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Geographic Points </td>
<td> All catgories</td>
<td> Everything below </td>
<td>  </td>
<td>  </td>
</tr>
<tr>
<td> Geographic Points </td>
<td> Manmade Places </td>
<td> Various things that don't fit into other categories </td>
<td> Dot </td>
<td> natural=wood, man_made=tower, water_tower, chimney, telephone_box, amenity=grave_yard, tourism=picnic_site and more </td>
</tr>
<tr>
<td> Geographic Points </td>
<td> Water Features </td>
<td> Various point water features (area may also be shown) </td>
<td> Dot </td>
<td> natural=water, drinking_water, leisure=marina, man_made=water_well, waterway=sluice_gate etc. </td>
</tr>
<tr>
<td> Geographic Points </td>
<td> Land Features </td>
<td> Various land point features (area may also be shown) </td>
<td> Dot </td>
<td> natural=tree, natural=peak, natural=bare_rock, landuse=cemetery </td>
</tr>
</table>

#### Others

<table border="1">
<tr>
<td> **Garmin Menu** </td>
<td> **Submenu** </td>
<td> **Description** </td>
<td> **Appears as** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Others </td>
<td> All catgories</td>
<td> Everything below </td>
<td>  </td>
<td>  </td>
</tr>
<tr>
<td> Others </td>
<td> Marine Services </td>
<td> Boat sales and services </td>
<td> Anchor </td>
<td> shop=boat, craft=boatbuilder </td>
</tr>
<tr>
<td> Others </td>
<td> Garmin Dealer </td>
<td> Various sorts of gates </td>
<td> G </td>
<td> barrier=gate, lift_gate, swing_gate, kissing_gate etc. </td>
</tr>
<tr>
<td> Others </td>
<td> Personal Service </td>
<td> Benches and shelters </td>
<td> Dot </td>
<td> amenity=bench, shelter </td>
</tr>
<tr>
<td> Others </td>
<td> Communications </td>
<td> Emergency phones </td>
<td> Dot </td>
<td> emergency=phone  </td>
</tr>
<tr>
<td> Others </td>
<td> Repair Service </td>
<td> Bicycle shops and services </td>
<td> Dot </td>
<td> shop=bicycle, bicycle_repair </td>
</tr>
<tr>
<td> Others </td>
<td> Social Service </td>
<td> Point features that don't fit into categories </td>
<td> Dot </td>
<td> highway=street_lamp, ford=yes, barrier=bollard, block, amenity=bicycle_parking, parcel_locker, clock, information=guidepost, board, map, route_marker, office, etc., man_made=monitoring_station, historic:railway=station and more </td>
</tr>
<tr>
<td> Others </td>
<td> Other </td>
<td> Nothing in this category </td>
<td> Dot </td>
<td> n/a </td>
</tr>
</table>

#### Items not on menus

Lots of things are shown on screen but don't aren't searchable.  To find out what Garmin menu an OSM feature has been mapped to, see [here](https://taginfo.openstreetmap.org/projects/someoneelse_mkgmap_ajt03#tags) and look for "not searchable".  See below for more detail.

## Rights of way, hiking trails, etc.

### Designations

Many designations are appended in brackets to paths, tracks and roads.

<table border="1">
<tr>
<td> **Description** </td>
<td> **Appended** </td>
<td> **Example OSM tags** </td>
</tr>
<tr>
<td> Public footpaths </td>
<td> PF </td>
<td> designation=public_footpath </td>
</tr>
<tr>
<td> Core paths (Scotland) </td>
<td> CP </td>
<td> designation=core_path </td>
</tr>
<tr>
<td> Public bridleways </td>
<td> PB </td>
<td> designation=public_bridleway </td>
</tr>
<tr>
<td> Restricted byways </td>
<td> RB </td>
<td> designation=restricted_bridleway </td>
</tr>
<tr>
<td> Byways open to all traffic </td>
<td> BY </td>
<td> designation=byway_open_to_all_traffic </td>
</tr>
<tr>
<td> Unclassified highways etc. </td>
<td> UH </td>
<td> designation=unclassified_highway </td>
</tr>
<tr>
<td> Quiet lanes </td>
<td> QL </td>
<td> designation=quiet_lane </td>
</tr>
</table>

### Long distance hiking routes

Hiking route relation names are added in brackets after the names (if any) of paths, tracks and roads.

### Informal

Informal paths have "(I)" appended.

## Quality control information on roads, tracks and paths

Objects with a fixme tag have "[fix]" appended to the name.

Roads have various letters appended:

* M  No speed limit defined where one would be expected.
* L  Not known if lit
* S  Not known if sidewalk
* V  No sidewalk, but not known if sidewalk

"[RD]" is appended to any "highway=road".

"[A]" is appended to footways etc. if no "foot" tag and one is expected.

Paths and tracks have various things appended for other missing tags:

* U  No surface tag
* O  No smoothness tag
* G  No tracktype tag

## Technical Details

This page describes how OpenStreetMap features are shown on the "03" map style [here](https://github.com/SomeoneElseOSM/mkgmap_style_ajt/), visible [here](../mkgmap_maps/ajt03/).

No .typ file is used.

Most map features are transferred in the same way as mkgmap's standard style.  The mkgmap style used can be found [here](https://github.com/SomeoneElseOSM/mkgmap_style_ajt/tree/master/ajt03).  Differences include:

* Names used on more objects
* Removal of some duplicates and "typing error mappings" from the style; these are now handled in lua.
* Hiking routes are shown

Extra information is added to a tag in round brackets, for example "(meadow)".

Tags useful for quality control are added to a tag in square brackets, for example "[fix]".

### Other highway processing

#### Roads and Paths

Some corridors are shown as paths.

Some rare highway tags are consolidated into "track".

Various tunnel tags are consolidated into "yes.

Golf features are shown as paths or tracks if no other appropriate tags exist.

Wide paths are shown as tracks.
Narrow tracks are shown as paths.

Narrow tertiary roads are shown as unclassified.

"highway=busway" is shown as "highway=service".

Roads with different names on left and right are shown with both names.

Names are suppressed on things that could be reasonably be thought to be sidewalks.

Unusual access tags such as "access:foot" are used if no more usual equivalent (here "foot") is available.

These maps are designed for foot access, so use tags such as "foot" are used for "is this private" etc. tests in place of "access".

## Other processing for specific objects

### Infrastructure and industrial landuse

Some rarer tags are consolidated into "man_made=wastewater_plant" and have "(sewage)" appended to the name.

Electricity substations have "(el. sub.)" appended.

A selection of industrial tags have the "landuse=industrial" tag added.

### Former telephone boxes

The current use is appended to the name, for example "(fmr phone defib)".

### Diplomatic

End-user diplomatic things are consolidated into "amenity=embassy".  Others (e.g. "diplomatic=trade_delegation") are shown as offices.

### Grass etc. landuse

Unnamed "amenity=biergarten" are shown as pub beer gardens, which is all they likely are.

Unlike the web maps on this site, "landuse=farmland" is not explicitly shown, and neither is the "landuse=farmgrass" computed tag (from agricultural pasture and agricultural meadows).  Meadows that would count as "farmgrass" have their landuse tag removed.

Many "green" features are shown as "leisure=park" wirh the type (e.g. "(common)") appended to the name.  
This includes:

* beer_garden (pub beer gardens)
* outdoor grass (grass-covered outdoor seating areas)
* garden (other gardens)
* grass (other grass)
* greenfield
* meadow
* showground (various showground tags)
* car boot sale
* playground
* village green
* scout camp
* fishing
* outdoor centre

Farmyards and greenhouse horticulture are consolidated into "landuse=farmyard" and a suffix is appended to the name.

Dog parks and "leisure=court" are shown as "leisure=pitch".

### Other landuse

Military landuse is labelled as such.

### Barriers

Fences, hedges and walls are all shown as black lines.  Fences have "(fence)" appended; hedges "(hedge)" and walls "(wall)".

### Tourism

Bird and wildlife hides are shown as tourist information with a suffix added to the name.
Guideposts, fingerposts and markers have "GP" appended to the name.
Route markers have "RM" appended to the name.
Various types of boards and maps have "B" appended to to name.
Signs have "S" appended to to name.
"destination" features have "DEST" appended.  "intermediary" ones have "INT".
Military signs have "MIL" appended.
Peak and Northern Footpath Society signposts have "PNFS" appended.
Guideposts that are "public right of way" markers have "PROW" appended.
Guideposts that sign a route have "ROUTE" appended.
NCN route markers are shown with "NCN", the marker type and the sustrans reference.

### Trees

"landuse=forestry" is handled as "landuse=forest".  Various tags are consolidated into "natural=wood".  "operator" is appended to the name, if present.

Broadleaved woodland has "B" appended in brackets; needleleaved has "C" and mixed "M".  "()" can be used as a QA tool to show that leaf_type has not been mapped yet.

### Shops and Amenities

See above for details of where these appear on the search menus.

Unnamed farm shops with particular produce are shown as farm "vending machines".


### Pubs and bars etc.

Pubs that are inaccessible (e.g. "access=no") are hidden.
Things that are both hotels and pubs are treated as pubs that do accommodation.
Some other things that serve real ale are treated as pubs, unless another tag is more relevant (e.g. brewery).  Other tags (e.g. "food=yes", for restaurants) are also added.
Pub beer gardens are handled as beer gardens (see "Grass etc. landuse" elsewhere).

All open pubs and bars have a suffix added, that contains:

* BQ (bars) or PQ (pubs)
* R if they serve real ale
* F if they serve food
* L if they have a noncarpeted floor
* UB if they are a microbrewery
* UP if they are a micropub
* A if they have accommodation
* G if there is a beer garden
* O if there is outside seating
* WY if they are wheelchair accessible
* WL if they have limited wheelchair access
* WN if they have no wheelchair access

Pubs that are allegedly still "closed due to covid" have an appropriate suffix added to the name.

Restaurants have "(restaurant)" added as a suffix, and also "(accomm)" if they have rooms.

### Railways

Razed railways and old inclined_planes are shown as dismantled.
Miniature railways (not handled in the style file) are shown as narrow_gauge.

### Healthcare

Vaccination centres are shown as clinics if no other tag applies.

### Water features

Intermittent waterways, water and wetlands have "(int)" appended to the name.
"waterway=leat" and "waterway=spillway" etc. are shown as drains.
"location=underground" waterways are shown as tunnels.
Lock references on waterways are shown.
Various rarer sorts of water are shown as "natural=water".

### Other

Various man_made edifices are hown as buildings, with a suffix saying what each one is.

