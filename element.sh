PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# check for argument
if [[ -z $1 ]]
then
 echo -e "Please provide an element as an argument."
else
# if argument is a number
  if [[ $1 =~ [0-9] ]]
  then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number = $1")
  fi
# if argument is a symbol
  if [[ $1 =~ [A-Za-z] ]]
  then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")
  fi
# if atomic number doesn't exist
  if [[ -z $ATOMIC_NUMBER ]]
  then
  echo "I could not find that element in the database."
  else 
# if atomic number does exist 
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER") 
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER") 
  TYPE=$($PSQL "SELECT type FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE name = '$NAME'") 
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER") 
  MELT_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER") 
  BOIL_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER") 
# output with element information
  echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
  fi
fi
