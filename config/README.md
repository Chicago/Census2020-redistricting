
# Census API key

Some API calls might require a Census key. 

Signing up for a census key is very simple:<br>
https://api.census.gov/data/key_signup.html

Store the key in `./config/census.yaml`.  This file should have a single line that looks like this:

```
census_key: 60179a296489e868d80e37a8e654dedf0bc5b0d4

```

(that's actually a scrambled version of my key)


# Stadia Key

For leaflet map tiles I was experimenting with Stadia (Stadia.AlidadeSmoothDark). However I had a problem exporting maps when the tiles require a key. So, it may be easiser to just use a different provider as documented in R with `?addProviderTiles`. I typically use CartoDB.DarkMatter or CartoDB.Positron. 

Check out previews for Stadia and other tiles here: http://leaflet-extras.github.io/leaflet-providers/preview/

You can register for a Stadia key here: https://stadiamaps.com/

The file `./config/stadia.yaml` should look like something this: 

```
stadia_key: ade88060-a3bb-409c-13a49b-c7de1197c5

```

# Note on EOL

Each config file should have a blank line at the end to avoid a warning, but it's just a warning if you don't have a line ending. 





