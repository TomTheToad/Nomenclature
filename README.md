# Nomenclature

<h1> Nomen: (noun) <i>latin</i> for name </h1>

<h2>What is it?</h2>
<p>Nomen is an iOS application which allows the user to lookup taxonomic data (kingdom, phylum, species, etc..) by common name, add an image, and save their findings to a card. The cards can be then be saved to individual collections, not dissimilar to a deck of cards.

<h2>Why?</h2>
<p>Simply put, I created this application for my son. My son has a strong interest in science and found the need for an easy means of looking up scientific names for organisms. I figured this would be a quick project that we would both enjoy.<p>I should mention that we did find a couple of apps on the app store which provided species names but little else. His interest was in the full measure of taxonomic data. Namely the Kingdom, Phylum, Class, Order, Family, Genus, and Species of an organism. So, again, I decided this might be a fun, quick application to build regardless of what was or wasn’t available.

<h2>Where did you get the information? That is, what apis did you use</h2>
<p>Our goto site has been <a href="https://www.itis.gov">ITIS</a> for data. The site, however, is hard for a child to use effectively and lacks images for the organisms. We did find other, excellent sites with images but either had no useful api, or an api that would require multiple calls to retrieve the whole taxonomic name. Admittedly, this could be a failure of my ability to fully grasp the associated documentation. Either way, the result is still the same. Since the <a href="https://www.itis.gov">ITIS</a> api lacked image support, I decided to include a general image search using <a href="https://www.flickr.com">flickr</a>. I was required to use them for previous school projects and was already fairly well versed in the usage of their api.

<h2>What do I need to run the code?</h2>
<p>If your already an ios developer, not much. You'll need Xcode 9 or later and a reliable net connection. Simply build and run the application.
  
  Step one: Clone, build and run the application.
  Step two: You'll be prompted to add a new Collection. Consider this a "deck" for "cards".
  Step three: Enter a name for your collection and continue.
  Step Four: Enter an organism to search ITIS.gov for. This could be a "Panda", "Dolphin" or other such animal.
    NOTE: ITIS.gov API is EXTREMELY case sensitive: "Red Fox", "Red fox", "red Fox", and "red fox" can all be very different     queries.
  Step Five: Add an image? If you like, and hopefully you will, you can search Flickr for an image of your organism. The default search will be the given common name of the organism from ITIS. You can modify your search at the top of the search window and reload by pressing the reload button.
  Step Six: Save your found organism!
 
 You now have a new collection with an organism inside! You can add another collection, look for the plus signs, or view your collection, click on it. 
 
 if you click on your collection you can either view by a scrollable collection of cards or by table. See the tab buttons at the bottom. You can add cards by looking for plus signs. In the table view you can delete cards by swipping. In the "card" or collection view you can view your cards by swipping or using the arrow buttons in the bottom bar. You can add an item by clicking the plus button. You can delete the current item shown by clicking the trash icon.
 
 Thanks for trying out Nomen!

<h2>Known Bugs</h2>
<p>This is an "in progress" application and, as such, does contain a bug or two ... or more. The most noteable issue the problem with displaying multiple common names properly. I've omitted it from this version for the sake of submission. 
  
<h2>Future Revisions</h2>
My intention with this app is to provide a means by which the user can create cards from multiple sources. This to include Wikipedia, using the Wikimedia api, iNaturalist, and Google image searches. This became a large task for this application as some of these items, such as wikimedia, would require data scraping methods. Something I'd prefer not to do. I've removed the api controller I created from this version for submission but would like to add them back to a future version. This way an individual Organism card can show multiple sources of information in various views to include curated web views.

I'd like to also enable the creation of blank cards so the user can create their add their own images and taxonomic data. This would eventually allow submission to ITIS and other taxonomic databases.

The design is by no means complete. Colors and images have been, and will continue to be, updated.

Each taxonomic item, especially the higher levels, should include a detail either spelling out a definition of the term or giving some more specific information.

I'd like to add a scroll View to the Organism card layout to replace the lone image with many possible images. I'd also like to give each image a title so that you can identify perhaps a male of the species, or a unique trait or situation pictured.

These are generally the major items I'd like to add.

<h2>Credit</h2>
Help?, Yes, I had allot of that. I used numerous api references from https://www.itis.gov/solr_examples.html. As always I poured over lessons from https://www.raywenderlich.com, Udacity.com, https://stackoverflow.com, and so many more. The code I put fourth, while uniquely my own (mess?) has been influenced by many people whom I thank profusely.
