#! /bin/bash
echo "-----------------------------"
echo "User Name : KimYeongyeom"
echo "Student Number : 12201710 "
echo "[  MENU  ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data'"
echo "4. Delete the ‘IMDb URL’ from ‘u.item'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release date' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "----------------------------"
while :
do
	read -p "Enter your choice [ 1-9 ] " reply
	if [ $reply -eq 9 ]; then
		echo "Bye!"
		break
	elif [ $reply -eq 1 ]; then
		read -p "Please enter the 'movie id' (1~1682) :" reply1
		awk -F\| -v findrow="$reply1" 'NR == findrow { print }' u.item
	elif [ $reply -eq 2 ]; then
		read -p "Do you want to get the data of ‘action’ genre movies from 'u.item’?(y/n) :" reply2
		if [ $reply2 = 'y' ]; then
			awk -F\| '$7 == 1 { print $1, $2 }' u.item | head -n 10
		fi
	elif [ $reply -eq 3 ]; then
		read -p "Please enter the 'movie id' (1~1682) :" reply3
		awk -v movieid="$reply3" -F'\t' '$2 == movieid { ratingcount++; ratingsum += $3} END { printf "average rating of %d : %.5f\n", movieid, ratingsum / ratingcount; }' u.data  
	elif [ $reply -eq 4 ]; then
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n) :" reply4
		if [ $reply4 = 'y' ]; then
			sed 's/|http[^|]*|/||/g' u.item | head -n 10
		fi
	elif [ $reply -eq 5 ]; then
		read -p "Do you want to get the data about users from 'u.user'?(y/n) :" reply5
		if [ $reply5 = 'y' ]; then
			sed 's/|/ /g' u.user | awk -F' ' '{printf "user %s is %s years old %s %s\n", $1, $2, $3=="M"?"male":"female", $4}' | head -n 10
		fi
	elif [ $reply -eq 6 ]; then
		read -p "Do you want to Modify the format of 'release data' in 'u.item?(y/n) :" reply6
		if [ $reply6 = 'y' ]; then
			sed -n '1673,1682 {
			  s/-Jan-/-01-/
			  s/-Feb-/-02-/
			  s/-Mar-/-03-/
			  s/-Apr-/-04-/
			  s/-May-/-05-/
			  s/-Jun-/-06-/
			  s/-Jul-/-07-/
			  s/-Aug-/-08-/
			  s/-Sep-/-09-/
			  s/-Oct-/-10-/
		          s/-Nov-/-11-/
			  s/-Dec-/-12-/
			  s/\([0-9]\{2\}\)-\([0-9]\{2\}\)-\([0-9]\{4\}\)/\3\2\1/
	                  p
		        }' u.item

		fi
	elif [ $reply -eq 7 ]; then
		read -p "Please enter the 'user id' (1~943) :" reply7
		awk -v userid="$reply7" '$1 == userid {print $2}' u.data | sort -n | tr '\n' '|'
		echo ""
		movieids=$(awk -v userid="$reply7" '$1 == userid {print $2}' u.data | sort -n)
		result=""
		for movieid in $movieids; do
			movietitle=$(awk -F "|" -v id="$movieid" '$1 == id {print $2}' u.item)
		        result+="$movieid|$movietitle\n"
		done
		echo -e "$result"

	elif [ $reply -eq 8 ]; then
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n) :" reply8
	fi
done
