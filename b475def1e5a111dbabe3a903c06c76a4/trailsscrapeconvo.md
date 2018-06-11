First: cool idea! 
Second: (and, again) 👍 for going above and beyond in trying to do the right thing.

Now for the blathering…

From everything I read on the site and verified in the REP (as you did), they don't prevent automated 
access to the basic trail information data. The fact that you didn't get a reply also likely means it's 
not something their administrative staff is briefed to handle or something that comes up often.

So, ultimately they state that the basic trail info is a public resource with no express prohibition of 
scraping use.

Now, there are some finer points to consider:

This boilerplate text:

>TrailLink is a free service provided by Rails-to-Trails Conservancy (a non-profit) and we need your support!

is in many places on the site. It's unlikely an R package would shunt a large enough number of 👀 away from 
their site to cause financial woes, but I likely would figure out how to include both a donation 
encouragement and link in with the data pkg documentation.

I also noticed that detailed trail info (including GPS track) requires registration to see (they 
redirected away from it when I refused to register in an incognito window).

I also noticed:

>The TrailLink app itself, as well as your first trail map download in the app, are free. You only need to register or login with your TrailLink account to redeem your free trail map. After you redeem your first free map, a map credit screen will automatically appear, so that you can purchase map credit bundles for additional maps. Each TrailLink map requires one map credit. Map credits may be purchased in the following bundles:
>
>3 Map Credit Pack:              $1.99
>7 Map Credit Pack:              $3.99
>15 Map Credit Pack:            $7.99
>
>If you plan to download several maps, you may be interested in TrailLink Unlimited, a digital subscription for $29.99 per year, which not only allows you to download unlimited maps for offline use in the TrailLink app or GPS units, but also provides the ability for you to create your own custom digital trail guides and custom routes on TrailLink.com.

and

<https://secure2.convio.net/rtt/site/Ecommerce/315461964?FOLDER=1030&store_id=1141>

What I glean from those is what you currently have in the data package is well within the implicit fair use 
(given the lack of scraping prohibition)
but if you were to add in actual trail GPS tracks then you'd be bumping up against their attempt to gain 
revenue from their non-profit activities. I'd personally steer clear of incorporating the GPS track data 
(perhaps a link to the page with the track data wld be a gd thing.

Having said that (see, I did warn abt "blather" :-) there would be nothing wrong with you having the 
trailhead lat/lng associated with the trail (since you can look that up) and doing some integration with
the [`tigris`](https://www.rdocumentation.org/packages/tigris/versions/0.5.3/topics/rails) package since
the older rail lines are likely in the census DB.  However, if you just want to make a data pkg, then that
-- too -- is cool.

In summary:

- no explicit prohibition even when they were contacted
- likely add donation information
- keep GPS tracks out of the pkg
- perhaps include lat/lng of trailhead and integrate `tigris` in some way
