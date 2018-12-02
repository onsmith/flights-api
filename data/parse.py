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


## Utility functions
def sort_by(a, k, r=False):
  return sorted(a, key=lambda x: x[k], reverse=r)


## Read data
airlines = read_airlines(airline_info['filename'], airline_info['csv_fields'])
airports = read_airports(airport_info['filename'], airport_info['csv_fields'])
flights  =  read_flights(flight_info['filename'],  flight_info['csv_fields'])
planes   =   read_planes(plane_info['filename'],   plane_info['csv_fields'])


## Airline filter function
def filter_airlines(airlines, flights):
  id_whitelist = set(f['airline_id'] for f in flights)
  return [
    a for a in airlines if
    a['active'] and
    a['id'] in id_whitelist
  ]


## Airport filter function
def filter_airports(airports, flights):
  id_whitelist_1 = set(f['departure_id'] for f in flights)
  id_whitelist_2 = set(f['arrival_id']   for f in flights)
  id_whitelist   = id_whitelist_1.union(id_whitelist_2)
  return [
    a for a in airports if
    a['code'] in airport_whitelist and
    a['id'] in id_whitelist
  ]


## Plane filter function
def filter_planes(planes, flights):
  code_whitelist = set(f['equipment'][0] for f in flights)
  return [
    p for p in planes if
    p['code'] in code_whitelist
  ]


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
    f['stops'] == '0' and
    len(f['equipment']) == 1 and
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


## Helper function to randomly generate true/false according to a probability
def bernoulli(p):
  return random.uniform(0, 1) < p


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
  'instances': instances
}


## Write to output
with open(output_file, 'w') as outfile:
  json.dump(data, outfile)


for flight in flights:
  print([(1 if i else 0) for i in flight['schedule']])


## Print results
print(len(flights),   'flights')
print(len(airports),  'airports')
print(len(airlines),  'airlines')
print(len(planes),    'planes')
print(len(instances), 'instances')