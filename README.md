# Normalizing-Spatial-Data-in-a-Real-Estate-Database

## *Objectives*
The objectives of this assignment were to gain a basic understanding of Third and Fourth Normal Form (3NF and 4NF) as well as reenforcing basic practices of data normalization and furthering practice of the First and Second Normal Form. This will be accomplished by first creating a dataset of different properties to sort build into a real estate database. The goal is to then put this data through 1NF, 2NF, 3NF and 4NF, as well as add a new address into this database.
### *Introduction*
Data Normalization is a technique in database design for the purpose of breaking down large, complex datasets into smaller more manageable tables. This reduces redundancies and dependencies within the data itself. Essentially it streamlines a dataset, so it becomes easier to deal with. Data Normalization is typically split into 4 different steps, as mentioned in Objectives, for the purposes of this excercise, the purpose is to put a database into all four normal forms.
### *Tools*
PostgreSQL with PostGIS extension
pgAdmin (for database management)
Git (Hub and Bash)
### *Methods*
First I created an extension to PostGIS. Following this I created the initial table for data to be populated into. This table is called, PropertyDetails and contains nine collumn, one for unique IDs (PropertyID) for each property, Address, City, State, Country, ZoningType, Utility, Geolocation and CityPopulation. I then created 6 unique properties based off of addresses found on Google Maps. I populated PropertyDetails with an INSERT command. PropertyDetails at this point is not in any normal form, so to put it into 1NF, I created a new table called Utilities, as the Utility column is not atomic in PropertyDetails. I also created a table for Property Addresses so they could have unique IDs of their own, which could be paired with the utilities using a foregin key. Following this, I populated the Utilities table with the utilites paired with their respective AddressIDs. I then used the ALTER TABLE command to remove the Utility column from PropertyDetails, thus putting it into 1NF. My next step was to elimate partial dependency so the database could meet the requirments of 2NF. To do this I created a table called CityDemographics. This table contains four columns, City (Primary key), State, Country and CityPopulation. I then altered PropertyDetails to drop the State and Country columns, utilizing the ALTER TABLE command once again. This also has now put the database into 3NF by eliminating transitive dependencies. To put it into 4NF (eliminating multivalued dependencies), I created two new tables, PropertyZoning, which contains three columns, a PropertyZoningID, the initial PropertyID and the ZoningType and, PropertyUtilities, also with three columns, a PropertyUtilitiesID, the initial PropertyID and Utility I then altered the PropertyDetails table once again by dropping the ZoningType and Utility columns. Lastly as an excercise in Spatial Database manipulation, a new property, with its respective Geolocation was added into the PropertyDetails table using the INSERT INTO command. This was then followed an attempt to query properties within a radius of that address using the format:

SELECT Address, City
FROM PropertyDetails
WHERE ST_DWithin(
    GeoLocation,
    ST_GeomFromText('POINT(-89.6501483 39.7817213)', 4326),
    10000 -- 10km radius
);

## *Conculsion*
This was a good introdution to the full spectrum of data normalization. This excercise helped me get a much better feel and a lot of good practice with the proper syntax of database management in PGAdmin. In the end I had many tables, which essentially separated the database into its component parts, making it lack redundancies and be ovverall easier to managem, if it were an actual database with real world purposes. While this excercise is useful for the purposes of learning methods and syntax, it still feels as though a database is disconnected in its parts, that rather then branching tables off from the original data populated table, I am simply, moving the data to a different table, that is why pretty much all of my tables are manually populated, which was a tedious process.
