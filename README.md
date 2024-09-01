# KaosKvltShopware
Modified Shopware Twig/Json Files and script to copy all orders from Database to local machine as csv, also turncate and drop all orders and customer datas.

The twig files modify shopware to:
- Remove register option for guests
- Remove user menu (because without register, there is no need for a user menu)
- Remove salutation because there are more than two genders and all customers should be called by name and not tagged as a gender
- Remove coupon code, because if the price should be dropped temporary, edit the price for all customers, not just for priviliged ones
- Remove cookie banner. No need if you just have a cookie for the cart
- Remove taxes, because KaosKvlt is a small business and don't need to show the priceses with and without taxes
- Edit some infomartion in the german language json, because KaosKvlt is a small business.
- Also add information like the legal site to the footer
