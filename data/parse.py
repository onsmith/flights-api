import csv
import json
import random
from datetime import timedelta, date
from math import cos, asin, sqrt


## Output json file
output_file = 'seed_data.json'


## Instance dates
instance_start_date = date(2018, 11, 28)
instance_end_date   = date(2019, 1, 15)


## Country whitelist
country_whitelist = [
  'United States',
  #'Mexico',
  #'Canada'
]


## Airport whitelist
# (Top 100 airports)
airport_whitelist = [
  'ATL', 'LAX', 'ORD', 'DFW', 'JFK', 'DEN', 'SFO', 'LAS', 'SEA', 'CLT',
  'PHX', 'MIA', 'MCO', 'IAH', 'EWR', 'MSP', 'BOS', 'DTW', 'LGA', 'PHL',
  'FLL', 'BWI', 'DCA', 'MDW', 'SLC', 'IAD', 'SAN', 'HNL', 'TPA', 'PDX',
  'DAL', 'STL', 'BNA', 'HOU', 'AUS', 'OAK', 'MSY', 'MCI', 'RDU', 'SJC',
  'SNA', 'SMF', 'SJU', 'IND', 'RSW', 'SAT', 'CLE', 'PIT', 'CMH', 'MKE',
  'OGG', 'CVG', 'PBI', 'BDL', 'JAX', 'ANC', 'ABQ', 'BUF', 'OMA', 'BUR',
  'ONT', 'MEM', 'OKC', 'CHS', 'PVD', 'RIC', 'RNO', 'BOI', 'GUM', 'SDF',
  'ORF', 'TUS', 'GEG', 'KOA', 'ELP', 'LIH', 'ALB', 'LGB', 'TUL', 'BHM',
  'GRR', 'SFB', 'DSM', 'ROC', 'SAV', 'DAY', 'GSP', 'PSP', 'MHT', 'SYR',
  'MYR', 'LIT', 'PIE', 'MSN', 'TYS', 'PWM', 'GSO', 'PNS', 'ICT', 'HPN'
]


## Airport data file
airport_info = {
  'filename': 'airports.dat',
  'csv_fields': [
    'id',
    'name',
    'city',
    'country',
    'IATA',
    'ICAO',
    'latitude',
    'longitude',
    'altitude',
    'timezone',
    'DST',
    'tz_timezone',
    'type',
    'source'
  ]
}


## Flights data file
flight_info = {
  'filename': 'routes.dat',
  'csv_fields': [
    'airline',
    'airline_id',
    'departure',
    'departure_id',
    'arrival',
    'arrival_id',
    'codeshare',
    'stops',
    'equipment'
  ]
}


## Airlines data file
airline_info = {
  'filename': 'airlines.dat',
  'csv_fields': [
    'id',
    'name',
    'alias',
    'IATA',
    'ICAO',
    'callsign',
    'country',
    'active'
  ]
}


## Planes data file
plane_info = {
  'filename': 'planes.dat',
  'csv_fields': [
    'name',
    'IATA',
    'IACO'
  ]
}


## Seat data
seat_data = {
  'Airbus A330-200': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/American_Airlines/American_Airlines_Airbus_A330-200_C.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 5, False, 'Business', ['A','C','F','H'], ['w','i','i','w']],
      [ 6, 8, False, 'Premium',  ['A','B','C','D','F','G','H'], ['w','i','i','','i','i','w']],
      [ 9,32, False, 'Economy',  ['A','B','C','D','E','F','G','H'], ['w','i','i','','','i','i','w']],
      [33,35, False, 'Economy',  ['A','B','C','D','F','G','H'], ['w','i','i','','i','i','w']],
      [36,36, False, 'Economy',  ['A','B','C','D','F'], ['w','i','i','','i']],
    ]
  },
  'Airbus A330-300': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/American_Airlines/American_Airlines_Airbus_A330_300.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 7, False, 'Business', ['A','C','F','H'], ['w','i','i','w']],
      [ 8,36, False, 'Economy',  ['A','B','C','D','E','F','G','H'], ['w','i','i','','','i','i','w']],
      [37,40, False, 'Economy',  ['A','B','C','D','F','G','H'], ['w','i','i','','i','i','w']],
      [41,41, False, 'Economy',  ['C','D','F'], ['i','','i']],
    ]
  },
  'Boeing 767-300': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/American_Airlines/American_Airlines_Boeing_767-300.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 8, False, 'Business', ['A','D','G','J'], ['wi','i','i','wi']],
      [12,13, False, 'Economy',  ['A','B','C','E','G','H','J'], ['w','i','i','','i','i','w']],
      [17,17, False, 'Economy',  ['A','B','H','J'], ['w','i','i','w']],
      [20,21,  True, 'Economy',  ['A','B','C','E','G','H','J'], ['w','i','i','','i','i','w']],
      [22,41, False, 'Economy',  ['A','B','C','E','G','H','J'], ['w','i','i','','i','i','w']],
      [42,44, False, 'Economy',  ['C','E','G'], ['i','','i']],
    ]
  },
  'Airbus A319': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/American_Airlines/American_Airlines_Airbus_A319.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 2, False,   'First', ['A','C','D','F'], ['w','i','i','w']],
      [ 8,13, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [14,14,  True, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [15,27, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
    ]
  },
  'Airbus A320': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/American_Airlines/American_Airlines_Airbus_A320.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 3, False,   'First', ['A','C','D','F'], ['w','i','i','w']],
      [ 4, 9, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [10,11,  True, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [12,26, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
    ]
  },
  'Airbus A321': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/American_Airlines/American_Airlines_Airbus_A321_V2.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 4, False,   'First', ['A','C','D','F'], ['w','i','i','w']],
      [ 8,10, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [11,11,  True, 'Economy', ['A','B','C','D','E'], ['w','','i','i','']],
      [12,21, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [22,23, False, 'Economy', ['D','E','F'], ['i','','w']],
      [24,24,  True, 'Economy', ['B','C','D','E'], ['','i','i','']],
      [25,36, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
    ]
  },
  'Boeing 737-800': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/American_Airlines/American_Airlines_Boeing_737-800_V2.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 3, 6, False,   'First', ['A','B','E','F'], ['w','i','i','w']],
      [ 7, 9, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [10,10, False, 'Economy', ['A','B','C','D','E','F'], ['','','i','i','','w']],
      [11,13, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [14,15,  True, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [16,30, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
    ]
  },
  'Boeing 757-200': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/American_Airlines/American_Airlines_AA_Boeing_757-200_F.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 3, False,   'First', ['A','C','D','F'], ['w','i','i','w']],
      [ 8,10, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [11,11, False, 'Economy', ['D','E','F'], ['i','','w']],
      [12,12,  True, 'Economy', ['D','E'], ['i','']],
      [13,13,  True, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [14,29, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [30,30,  True, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [31,37, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [38,38, False, 'Economy', ['A','B','C'], ['w','','i']],
    ]
  },
  'Embraer RJ140': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/American_Airlines/American_Airlines_Embraer_ERJ-140.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 1,  True, 'Economy', ['A'], ['wi']],
      [ 2, 2, False, 'Economy', ['A'], ['wi']],
      [ 3,10, False, 'Economy', ['A','B','C'], ['wi','i','w']],
      [11,11,  True, 'Economy', ['A','B','C'], ['wi','i','w']],
      [12,16, False, 'Economy', ['A','B','C'], ['wi','i','w']],
    ]
  },
  'Embraer RJ145': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/American_Airlines/American_Airlines_Embraer_ERJ-145.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 1,  True, 'Economy', ['A'], ['wi']],
      [ 2, 2, False, 'Economy', ['A'], ['wi']],
      [ 3,11, False, 'Economy', ['A','B','C'], ['wi','i','w']],
      [12,12,  True, 'Economy', ['A','B','C'], ['wi','i','w']],
      [13,18, False, 'Economy', ['A','B','C'], ['wi','i','w']],
    ]
  },
  'Boeing 737-300': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/Jet2com/Jet2_Boeing_737-300.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 1, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [ 2,11, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [12,12,  True, 'Economy', ['B','C','D','E'], ['','i','i','']],
      [14,14,  True, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [15,26, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
    ]
  },
  'Boeing 737-400': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/Alaska_Airlines/Alaska_Airlines_Boeing_737-400.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 3, False, 'First', ['A','C','D','F'], ['w','i','i','w']],
      [ 6,11, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [15,15, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [16,17,  True, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [18,30, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
    ]
  },
  'Boeing 737-700': {
    'seatmap_url': 'https://www.seatguru.com/airlines/Alaska_Airlines/Alaska_Airlines_Boeing_737-700.php',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 3, False, 'First', ['A','C','D','F'], ['w','i','i','w']],
      [ 6,10, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [15,15, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [16,16,  True, 'Economy', ['B','C','D','E'], ['','i','i','']],
      [17,17,  True, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [18,28, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
    ]
  },
  'Embraer 190': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/Air_Canada/Air_Canada_Embraer_190.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 3, False, 'Business', ['A','D','F'], ['wi','i','w']],
      [12,18, False, 'Economy', ['A','C','D','F'], ['w','i','i','w']],
      [19,19,  True, 'Economy', ['A','C','D','F'], ['w','i','i','w']],
      [20,33, False, 'Economy', ['A','C','D','F'], ['w','i','i','w']],
    ]
  },
  'Boeing 737-500': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/UTair_Aviation/UTair_Aviation_Boeing_737-500A.jpg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 9, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [10,10,  True, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [11,21, False, 'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
    ]
  },
  'De Havilland Canada DHC-8-300 Dash 8': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/Air_Canada/Air_Canada_Dash_83.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 1,  True, 'Economy', ['A','C','D','F'], ['w','i','i','w']],
      [ 2, 9, False, 'Economy', ['A','C','D','F'], ['w','i','i','w']],
      [10,10,  True, 'Economy', ['A','C','D','F'], ['w','i','i','w']],
      [11,12, False, 'Economy', ['A','C','D','F'], ['w','i','i','w']],
      [13,13, False, 'Economy', ['A','C'], ['w','i']],
    ]
  },
  'Saab SF340A/B': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/Regional_Express/Regional_Express_SAAB_340B.jpg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 1,  True, 'Economy', ['A','B','C'], ['wi','i','w']],
      [ 2, 2, False, 'Economy', ['A','B','C'], ['i','i','']],
      [ 3, 5, False, 'Economy', ['A','B','C'], ['wi','i','w']],
      [ 6, 6,  True, 'Economy', ['A','B','C'], ['wi','i','w']],
      [ 7,11, False, 'Economy', ['A','B','C'], ['wi','i','w']],
    ]
  },
  'McDonnell Douglas MD-88': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/Delta_Airlines/Delta_Airlines_MD-88_2.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 4, False,   'First', ['A','B','C','D'], ['w','i','i','w']],
      [10,14, False, 'Comfort', ['A','B','C','D','E'], ['w','','i','i','w']],
      [15,23, False, 'Economy', ['A','B','C','D','E'], ['w','','i','i','w']],
      [24,25,  True, 'Economy', ['A','B','C','D','E'], ['w','','i','i','w']],
      [26,31, False, 'Economy', ['A','B','C','D','E'], ['w','','i','i','w']],
      [32,32, False, 'Economy', ['B','C','D','E'], ['','i','i','w']],
      [33,33,  True, 'Economy', ['A','B','C','D','E'], ['w','','i','i','w']],
      [34,35, False, 'Economy', ['A','B','C','D','E'], ['w','','i','i','w']],
      [36,36, False, 'Economy', ['A','B','D','E'], ['w','i','i','w']],
    ]
  },
  'McDonnell Douglas MD-90': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/Delta_Airlines/Delta_Airlines_MD-90.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 4, False,   'First', ['A','B','C','D'], ['w','i','i','w']],
      [10,14, False, 'Comfort', ['A','B','C','D','E'], ['w','i','i','','w']],
      [15,24, False, 'Economy', ['A','B','C','D','E'], ['w','i','i','','w']],
      [25,25,  True, 'Economy', ['B','C','D'], ['i','i','']],
      [26,27,  True, 'Economy', ['A','B','C','D','E'], ['w','i','i','','w']],
      [28,33, False, 'Economy', ['A','B','C','D','E'], ['w','i','i','','w']],
      [34,35, False, 'Economy', ['C','D','E'], ['i','','w']],
      [36,38, False, 'Economy', ['A','B','C','D','E'], ['w','i','i','','w']],
      [39,39, False, 'Economy', ['C','D','E'], ['i','','w']],
    ]
  },
  'Aerospatiale/Alenia ATR 72': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/Jet_Airways/Jet_Airways_ATR72.jpg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 1,  True, 'Economy', ['A','C','D','F'], ['w','i','i','w']],
      [ 2,16, False, 'Economy', ['A','C','D','F'], ['w','i','i','w']],
      [17,17, False, 'Economy', ['A','C'], ['w','i']],
    ]
  },
  'Boeing 777': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/American_Airlines/American_Airlines_Boeing_777-200_B.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 5, False, 'Business', ['A','D','H','L'], ['w','i','i','w']],
      [ 6, 6, False, 'Business', ['L'], ['w']],
      [ 7,12, False, 'Business', ['A','D','H','L'], ['w','i','i','w']],
      [13,21, False,  'Economy', ['A','B','C','D','E','H','J','K','L'], ['w','','i','i','','i','i','','w']],
      [22,22, False, 'Economy', ['A','B'], ['w','i']],
      [26,26,  True, 'Economy', ['A','B','C','D','E','G','H','J','K','L'], ['w','','i','i','','','i','i','','w']],
      [27,35, False, 'Economy', ['A','B','C','D','E','G','H','J','K','L'], ['w','','i','i','','','i','i','','w']],
      [36,38, False, 'Economy', ['A','C','D','E','G','H','J','L'], ['w','i','i','','','i','i','w']],
      [39,40, False, 'Economy', ['D','E','G','H'], ['i','','','i']],
    ]
  },
  'Boeing 787-8': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/American_Airlines/American_Airlines_Boeing_787-8.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 7, False, 'Business', ['A','D','H','L'], ['w','i','i','w']],
      [ 8,17, False,  'Economy', ['A','B','C','D','E','H','J','K','L'], ['w','','i','i','','i','i','','w']],
      [18,18, False,  'Economy', ['A','B','D','E','H','K','L'], ['w','i','i','','i','i','w']],
      [19,19,  True,  'Economy', ['A','B','C','J','K','L'], ['w','','i','i','','w']],
      [20,28, False,  'Economy', ['A','B','C','D','E','H','J','K','L'], ['w','','i','i','','i','i','','w']],
      [29,30, False,  'Economy', ['A','C','D','E','H','J','L'], ['w','i','i','','i','i','w']],
    ]
  },
  'Boeing 757': {
    'seatmap_url': 'https://cdn.seatguru.com/en_US/img/20181116212442/seatguru/airlines_new/American_Airlines/American_Airlines_Boeing_757-200_MCE_Intl_new.svg',
    'seats': [
      # row_start, row_end, is_exit, class, number, isle/window
      [ 1, 4, False, 'Business', ['A','B','E','F'], ['w','i','i','w']],
      [ 9, 9,  True,  'Economy', ['B','C','D','E'], ['','i','i','']],
      [10,16, False,  'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [17,18,  True,  'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
      [19,36, False,  'Economy', ['A','B','C','D','E','F'], ['w','','i','i','','w']],
    ]
  },
}


## Helper function to randomly generate true/false according to a probability
def bernoulli(p):
  return random.uniform(0, 1) < p


## Reads planes into list
def read_planes(filename, fields):
  planes = []
  with open(filename, encoding="utf-8") as csvfile:
    reader = csv.DictReader(csvfile, fieldnames=fields)
    for row in reader:
      planes.append({
        'name': row['name'],
        'code': row['IATA']
      })
  return planes


## Reads airlines into list
def read_airlines(filename, fields):
  airlines = []
  with open(filename, encoding="utf-8") as csvfile:
    reader = csv.DictReader(csvfile, fieldnames=fields)
    for row in reader:
      airlines.append({
        'id':     row['id'],
        'name':   row['name'],
        'active': row['active'] 
      })
  return airlines


## Reads airports into list
def read_airports(filename, fields):
  airports = []
  with open(filename, encoding="utf-8") as csvfile:
    reader = csv.DictReader(csvfile, fieldnames=fields)
    for row in reader:
      airports.append({
        'id':        row['id'],
        'code':      row['IATA'],
        'name':      row['name'],
        'city':      row['city'],
        'country':   row['country'],
        'latitude':  row['latitude'],
        'longitude': row['longitude']
      })
  return airports


## Reads flights into list
def read_flights(filename, fields):
  flights = []
  with open(filename, encoding="utf-8") as csvfile:
    reader = csv.DictReader(csvfile, fieldnames=fields)
    for row in reader:
      flights.append({
        'airline_id':   row['airline_id'],
        'departure_id': row['departure_id'],
        'arrival_id':   row['arrival_id'],
        'stops':        row['stops'],
        'equipment':    row['equipment'].split(' ')
      })
  return flights


## Read data
airlines = read_airlines(airline_info['filename'], airline_info['csv_fields'])
airports = read_airports(airport_info['filename'], airport_info['csv_fields'])
flights  =  read_flights(flight_info['filename'],  flight_info['csv_fields'])
planes   =   read_planes(plane_info['filename'],   plane_info['csv_fields'])


## Remove inactive airlines
airlines = [a for a in airlines if a['active'] == 'Y']


## Whitelist airports
airports = [a for a in airports if a['code'] in airport_whitelist]


## Remove flights with multiple stops
flights = [f for f in flights if f['stops'] == '0']


## Remove flights that use multiple airplanes
flights = [f for f in flights if len(f['equipment']) == 1]


## Remove planes without seats
planes = [p for p in planes if p['name'] in list(seat_data.keys())]


## Airline filter function
def filter_airlines(airlines, flights):
  id_whitelist = set(f['airline_id'] for f in flights)
  return [a for a in airlines if a['id'] in id_whitelist]


## Airport filter function
def filter_airports(airports, flights):
  id_whitelist_1 = set(f['departure_id'] for f in flights)
  id_whitelist_2 = set(f['arrival_id']   for f in flights)
  id_whitelist   = id_whitelist_1.union(id_whitelist_2)
  return [a for a in airports if a['id'] in id_whitelist]


## Plane filter function
def filter_planes(planes, flights):
  code_whitelist = set(f['equipment'][0] for f in flights)
  return [p for p in planes if p['code'] in code_whitelist]


## Flight filter function
def filter_flights(flights):
  airport_id_whitelist = [a['id'] for a in airports]
  airline_id_whitelist = [a['id'] for a in airlines]
  plane_code_whitelist = [p['code'] for p in planes]
  return [
    f for f in flights if
    f['departure_id'] in airport_id_whitelist and
    f['arrival_id'] in airport_id_whitelist and
    f['airline_id'] in airline_id_whitelist and
    f['equipment'][0] in plane_code_whitelist
  ]


## Gets the length of all four resources
def get_num_records(flights, airports, airlines, planes):
  return [len(flights), len(airports), len(airlines), len(planes)]


## Filter records
num_records = [0, 0, 0, 0]
while num_records != get_num_records(flights, airports, airlines, planes):
  num_records = get_num_records(flights, airports, airlines, planes)
  flights  = filter_flights(flights)
  airlines = filter_airlines(airlines, flights)
  airports = filter_airports(airports, flights)
  planes   = filter_planes(planes, flights)


## Distance between two global points
def distance(lat1, lon1, lat2, lon2):
  p = 0.017453292519943295     # Pi / 180
  a = 0.5 - cos((lat2 - lat1) * p)/2 + cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2
  return 12742 * asin(sqrt(a)) # 2 * R * asin...


## Flight distance to travel time in hours
def distance_to_time(d):
  # 800 kmph plus 40 minutes for take off and landing
  return d/800 + 0.667


## Finds a record by id
def find_by_id(a, id):
  return [i for i in a if i['id'] == id][0]


## Make random flight times
for f in flights:
  dep = find_by_id(airports, f['departure_id'])
  arr = find_by_id(airports, f['arrival_id'])
  dist = distance(
    float(dep['latitude']),
    float(dep['longitude']),
    float(arr['latitude']),
    float(arr['longitude'])
  )
  time = distance_to_time(dist)
  time_h = int(time)
  time_m = int((time - time_h) * 60)
  dep_h = random.randint(0, 23)
  dep_m = random.randint(0, 59)
  arr_h = dep_h + time_h
  arr_m = dep_m + time_m
  if arr_m >= 60:
    arr_m -= 60
    arr_h += 1
  arr_h = arr_h % 24
  f['departs_at'] = "%02d:%02d" % (dep_h, dep_m)
  f['arrives_at'] = "%02d:%02d" % (arr_h, arr_m)


## Randomly generate instance schedules for each flight
for flight in flights:
  p = random.uniform(0, 1)
  if p < 0.4:   # 40% Once-a-week flights
    p = 0.2
  elif p < 0.6: # 20% Every day flights 
    p = 1.0
  else:         # 40% Most days flights
    p = 0.6
  flight['schedule'] = [
    bernoulli(p),
    bernoulli(p),
    bernoulli(p),
    bernoulli(p),
    bernoulli(p),
    bernoulli(p),
    bernoulli(p)
  ]


## Helper function to iterate over dates
def daterange(start_date, end_date):
  for n in range(int ((end_date - start_date).days)):
    yield start_date + timedelta(n)


## Make instances
instances = []
for i, single_date in enumerate(daterange(instance_start_date, instance_end_date)):
  for j, flight in enumerate(flights):
    flight['id'] = j
    weekday = i % len(flight['schedule'])
    if flight['schedule'][weekday]:
      instances.append({
        'flight_id': flight['id'],
        'date': str(single_date),
        'is_cancelled': bernoulli(0.05)
      })


## Make seats
seats = []
for plane_name, data in seat_data.items():
  plane = [p for p in planes if p['name'] == plane_name][0]
  plane['seatmap_url'] = data['seatmap_url']
  for seat in data['seats']:
    for row in range(seat[0], seat[1]+1):
      for number in range(len(seat[4])):
        seats.append({
          'plane_id': plane['code'],
          'row': row,
          'number': seat[4][number],
          'cabin': seat[3],
          'is_window': ('w' in seat[5][number]),
          'is_aisle': ('i' in seat[5][number]),
          'is_exit': seat[2]
        })


## Make json
data = {
  'airlines': [{
    'id':   a['id'],
    'name': a['name']
    } for a in airlines
  ],
  'airports': [{
    'id':        a['id'],
    'name':      a['name'],
    'code':      a['code'],
    'latitude':  a['latitude'],
    'longitude': a['longitude'],
    'city':      a['city']
    } for a in airports
  ],
  'flights': [{
    'id':           f['id'],
    'departs_at':   f['departs_at'],
    'arrives_at':   f['arrives_at'],
    'number':       "%03d" % i,
    'plane_id':     f['equipment'][0],
    'airline_id':   f['airline_id'],
    'departure_id': f['departure_id'],
    'arrival_id':   f['arrival_id']
    } for i, f in enumerate(flights)
  ],
  'planes': [{
    'id':   p['code'],
    'name': p['name']
    } for p in planes
  ],
  'instances': instances,
  'seats': seats
}


## Write to output
with open(output_file, 'w') as outfile:
  json.dump(data, outfile)


## Print results
print(len(flights),   'flights')
print(len(airports),  'airports')
print(len(airlines),  'airlines')
print(len(planes),    'planes')
print(len(instances), 'instances')
print(len(seats), 'seats')