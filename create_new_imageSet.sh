# declare -a arr=("Monkfish" "Perch (Freshwater)" "Sablefish" "Skate" "Snapper" "Tuna (Canned chunk light)" "Tuna (Skipjack)" "Weakfish (Sea Trout)" "Mackerel (Spanish, Gulf)" "Sea Bass (Chilean)" "Tuna (Canned Albacore)" "Tuna (Yellowfin)" "Tuna (Bigeye, Ahi)")
declare -a arr=("Halibut (Atlantic)", "Halibut (Pacific)")

## now loop through the above array
for i in "${arr[@]}"
do
   mkdir "FishImages/$i.imageset"
   cp "FishImages/Mullet.imageset/Contents.json" "FishImages/$i.imageset/"
   # or do whatever with individual element of the array
done
