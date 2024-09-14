#!/bin/bash

EXPORTPATH=$1
echo -e id\;parent_id\;product_number\;active\;stock\;name\;description\;price_net\;price_gross\;purchase_prices_net\;purchase_prices_gross\;tax_id\;tax_rate\;tax_name\;cover_media_id\;cover_media_url\;cover_media_title\;cover_media_alt\;manufacturer_id\;manufacturer_name\;categories\;sales_channel\;propertyIds\;optionIds > $EXPORTPATH

while : ; do
  printf "Press 'a' to add\nPress 'q' to exit\n"
  read -n 1 k <&1
      if [[ $k = a ]] ; then
	  read -p "Enter ProductNo [KAS-1XXXX/KK-1XXXXX/MU-1XXXXX]: " PRODUCTNOM
	  read -p "Enter Name: " NAME
	  read -p "Enter description [\!\"\']: " DESCRIPTION

          while : ; do
              read -p "Enter Price for Customer [1.00]: " PRICE
              INT='^[+-]?[0-9]+([.][0-9]+)?$'
              if [[ $PRICE =~ $INT ]]; then
                  PRICE=$PRICE
                  PRICEWOT=$(bc <<< "scale=2; $PRICE/119*100")
                  break
              fi
          done

          while : ; do
              read -p "Enter Flavor [kas/kk/mu]: " FLAVOR
                  if [[ $FLAVOR == "kk" ]]; then
                      FLAVOR='"Kaos Kvlt"'
                      MANID='0191ef40e4dd754881c726e70a0984c8'
                      FLAVCAT='0191d35a0d387432895e58a7fb0184da'
                      break
                  elif [[ $FLAVOR == "kas" ]]; then
                      FLAVOR='"Kasiandras-Dreams"'
                      MANID='0191c6aad3757849b540002b192b05db'
                      FLAVCAT='0191d35a3e2078438c285181f07974f3'
                      break
                  elif [[ $FLAVOR == "mu" ]]; then
                      FLAVOR='"Mullana"'
                      MANID='0191c695af9d7825b374526501f5ff71'
                      FLAVCAT='0191d35a2a357c19a52f70c802184786'
                      break
                  fi
          done
          while : ; do
              read -p "Enter Category [Sticker/Flag/Postkarten/Poster]: " CATEGORY
                  if [[ $CATEGORY == "Sticker" ]]; then
                      CATID='0191c6992a91739892acd0811bd73fd9'
                      break
                  elif [[ $CATEGORY == "Flag" ]]; then
                      CATID='0191c69943d972609ef9cd06c0baeb16'
                      break
                  elif [[ $CATEGORY == "Postkarten" ]]; then
                      CATID='0191c69933e77564b597a642ab5ff9de'
                      break
                  elif [[ $CATEGORY == "Poster" ]]; then
                      CATID='0191ef628a997ee2bfc03e0e016b2c76'
                      break
                  fi
          done
      elif [[ $k = q ]] ; then
          printf "\nQuitting from the program\n"
          break
    fi
    echo -e \;\;$PRODUCTNOM\;1\;50\;\"$NAME\"\;\"${DESCRIPTION}\"\;$PRICEWOT\;$PRICE\;0\;0\;0191aa1581a573949d30a2dddbd51f02\;19\;\"Standard rate\"\;\;\;\;\;$MANID\;$FLAVOR\;$CATID\|$FLAVCAT\;0191aa17581b72958d6c9ca950e2dc20\;\; >> $EXPORTPATH
done
