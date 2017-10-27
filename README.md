# Nomenclature

<h1> Nomen: (noun) <i>latin</i> for name </h1>

<h2>What is it?</h2>
<p>Nomen is an iOS application which allows the user to lookup taxonomic data (kingdom, phylum, species, etc..) by common name, add an image, and save their findings to a card. The cards can be then be saved to individual collections, not disimilar to a deck of cards.

<h2>Why?</h2>
<p>Simply put, I created this application for my son. My son has a strong interest in science and found the need for an easy means of looking up scientific names for organisms. I figured this would be a quick project that we would both enjoy.<p>I should mention that we did find a couple of apps on the app store which provided species names but little else. His interest was in the full measure of taxonomic data. Namely the Kingdom, Phylum, Class, Order, Family, Genus, and Species of an organism. So, again, I decided this might be a fun, quick application to build regardless of what was or wasn’t available.

<h2>Where did you get the information? That is, what apis did you use</h2>
<p>Our goto site has been <a href="https://www.itis.gov">ITIS</a> for data. The site, however, is hard for a child to use effectively and lacks images for the organisms. We did find other, excellent sites with images but either had no useful api, or an api that would require multiple calls to retrieve the whole taxonomic name. Admittedly, this could be a failure of my ability to fully grasp the associated documentation. Either way, the result is still the same. Since the <a href="https://www.itis.gov">ITIS</a> api lacked image support, I decided to include a general image search using <a href="https://www.flickr.com">flickr</a>. I was required to use them for previous school projects and was already fairly well versed in the usage of their api.

<h2>What do I need to run the code?</h2>
<p>If your already an ios developer, not much. You'll need Xcode 9 or later and a reliable net connection. Simply build and run the application. There are still some bugs to work out. Namely the complicated card interface tends to have constraint issues on the 5S.

<h2>Known Bugs</h2>
<p>This is an "in progress" application and, as such, does contain a bug or two ... or more. The primary issue I'm currently working with is adapting a custom collectionViewFlowLayout to work seemlessly with a collection containing cells which contain a custom table. This is what allows the user to casually page between organims in the collection view. I'm currently hunting down missing constraints somewhere within the tableCell or UICollection view which breaks on smaller screen sizes.<p> I'll update this as I get further into testing the application on different devices. I could use a scrollView instead but I wanted the benefits of having reusable table and collection cells versus loading, building a scroll view all at once. Ultimately, I've really wanted to tackle the problem of including one type of collection within another.
