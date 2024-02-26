(async function() {
          while (!Spicetify.React || !Spicetify.ReactDOM) {
            await new Promise(resolve => setTimeout(resolve, 10));
          }
          "use strict";
var stats = (() => {
  var __create = Object.create;
  var __defProp = Object.defineProperty;
  var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
  var __getOwnPropNames = Object.getOwnPropertyNames;
  var __getProtoOf = Object.getPrototypeOf;
  var __hasOwnProp = Object.prototype.hasOwnProperty;
  var __commonJS = (cb, mod) => function __require() {
    return mod || (0, cb[__getOwnPropNames(cb)[0]])((mod = { exports: {} }).exports, mod), mod.exports;
  };
  var __copyProps = (to, from, except, desc) => {
    if (from && typeof from === "object" || typeof from === "function") {
      for (let key of __getOwnPropNames(from))
        if (!__hasOwnProp.call(to, key) && key !== except)
          __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
    }
    return to;
  };
  var __toESM = (mod, isNodeMode, target) => (target = mod != null ? __create(__getProtoOf(mod)) : {}, __copyProps(
    isNodeMode || !mod || !mod.__esModule ? __defProp(target, "default", { value: mod, enumerable: true }) : target,
    mod
  ));

  // external-global-plugin:react
  var require_react = __commonJS({
    "external-global-plugin:react"(exports, module) {
      module.exports = Spicetify.React;
    }
  });

  // src/extensions/extension.tsx
  var import_react8 = __toESM(require_react());

  // src/pages/playlist.tsx
  var import_react7 = __toESM(require_react());

  // src/components/cards/stat_card.tsx
  var import_react = __toESM(require_react());
  function formatValue(name, value) {
    switch (name) {
      case "tempo":
        return `${Math.round(value)} bpm`;
      case "popularity":
        return `${Math.round(value)} %`;
      default:
        return `${Math.round(value * 100)} %`;
    }
  }
  function normalizeString(inputString) {
    return inputString.charAt(0).toUpperCase() + inputString.slice(1).toLowerCase();
  }
  function StatCard(props) {
    const { TextComponent } = Spicetify.ReactComponent;
    const { label, value } = props;
    return /* @__PURE__ */ import_react.default.createElement("div", {
      className: "main-card-card"
    }, /* @__PURE__ */ import_react.default.createElement(TextComponent, {
      as: "div",
      semanticColor: "textBase",
      variant: "alto",
      children: typeof value === "number" ? formatValue(label, value) : value
    }), /* @__PURE__ */ import_react.default.createElement(TextComponent, {
      as: "div",
      semanticColor: "textBase",
      variant: "balladBold",
      children: normalizeString(label)
    }));
  }
  var stat_card_default = StatCard;

  // src/components/cards/genres_card.tsx
  var import_react2 = __toESM(require_react());
  var genreLine = (name, value, limit, total) => {
    return /* @__PURE__ */ import_react2.default.createElement("div", {
      className: "stats-genreRow"
    }, /* @__PURE__ */ import_react2.default.createElement("div", {
      className: "stats-genreRowFill",
      style: {
        width: `calc(${value / limit * 100}% + ${(limit - value) / (limit - 1) * 100}px)`
      }
    }, /* @__PURE__ */ import_react2.default.createElement("span", {
      className: "stats-genreText"
    }, name)), /* @__PURE__ */ import_react2.default.createElement("span", {
      className: "stats-genreValue"
    }, Math.round(value / total * 100) + "%"));
  };
  var genreLines = (genres, total) => {
    return genres.map(([genre, value]) => {
      return genreLine(genre, value, genres[0][1], total);
    });
  };
  var genresCard = ({ genres, total }) => {
    const genresArray = genres.sort(([, a], [, b]) => b - a).slice(0, 10);
    return /* @__PURE__ */ import_react2.default.createElement("div", {
      className: `main-card-card stats-genreCard`
    }, genreLines(genresArray, total));
  };
  var genres_card_default = genresCard;

  // src/components/cards/spotify_card.tsx
  var import_react3 = __toESM(require_react());
  function SpotifyCard(props) {
    const { Cards, TextComponent, ArtistMenu, AlbumMenu, ContextMenu } = Spicetify.ReactComponent;
    const { Default: Card, CardImage } = Cards;
    const { type, header, uri, imageUrl, subheader } = props;
    const Menu = () => {
      switch (type) {
        case "artist":
          return /* @__PURE__ */ import_react3.default.createElement(ArtistMenu, {
            uri
          });
        case "album":
          return /* @__PURE__ */ import_react3.default.createElement(AlbumMenu, {
            uri
          });
        default:
          return /* @__PURE__ */ import_react3.default.createElement(import_react3.default.Fragment, null);
      }
    };
    const lastfmProps = type === "lastfm" ? { onClick: () => window.open(uri, "_blank"), isPlayable: false, delegateNavigation: true } : {};
    return /* @__PURE__ */ import_react3.default.createElement(ContextMenu, {
      menu: /* @__PURE__ */ import_react3.default.createElement(Menu, null),
      trigger: "right-click"
    }, /* @__PURE__ */ import_react3.default.createElement(Card, {
      featureIdentifier: type,
      headerText: header,
      renderCardImage: () => /* @__PURE__ */ import_react3.default.createElement(CardImage, {
        images: [{
          height: 640,
          url: imageUrl,
          width: 640
        }],
        isCircular: type === "artist"
      }),
      renderSubHeaderContent: () => /* @__PURE__ */ import_react3.default.createElement(TextComponent, {
        as: "div",
        variant: "mesto",
        semanticColor: "textSubdued",
        children: subheader
      }),
      uri,
      ...lastfmProps
    }));
  }
  var spotify_card_default = SpotifyCard;

  // src/components/status.tsx
  var import_react4 = __toESM(require_react());
  var ErrorIcon = () => {
    return /* @__PURE__ */ import_react4.default.createElement("svg", {
      "data-encore-id": "icon",
      role: "img",
      "aria-hidden": "true",
      viewBox: "0 0 24 24",
      className: "status-icon"
    }, /* @__PURE__ */ import_react4.default.createElement("path", {
      d: "M11 18v-2h2v2h-2zm0-4V6h2v8h-2z"
    }), /* @__PURE__ */ import_react4.default.createElement("path", {
      d: "M12 3a9 9 0 1 0 0 18 9 9 0 0 0 0-18zM1 12C1 5.925 5.925 1 12 1s11 4.925 11 11-4.925 11-11 11S1 18.075 1 12z"
    }));
  };
  var LibraryIcon = () => {
    return /* @__PURE__ */ import_react4.default.createElement("svg", {
      role: "img",
      height: "46",
      width: "46",
      "aria-hidden": "true",
      viewBox: "0 0 24 24",
      "data-encore-id": "icon",
      className: "status-icon"
    }, /* @__PURE__ */ import_react4.default.createElement("path", {
      d: "M14.5 2.134a1 1 0 0 1 1 0l6 3.464a1 1 0 0 1 .5.866V21a1 1 0 0 1-1 1h-6a1 1 0 0 1-1-1V3a1 1 0 0 1 .5-.866zM16 4.732V20h4V7.041l-4-2.309zM3 22a1 1 0 0 1-1-1V3a1 1 0 0 1 2 0v18a1 1 0 0 1-1 1zm6 0a1 1 0 0 1-1-1V3a1 1 0 0 1 2 0v18a1 1 0 0 1-1 1z"
    }));
  };
  var Status = (props) => {
    const [isVisible, setIsVisible] = import_react4.default.useState(false);
    import_react4.default.useEffect(() => {
      const to = setTimeout(() => {
        setIsVisible(true);
      }, 500);
      return () => clearTimeout(to);
    }, []);
    return isVisible ? /* @__PURE__ */ import_react4.default.createElement(import_react4.default.Fragment, null, /* @__PURE__ */ import_react4.default.createElement("div", {
      className: "stats-loadingWrapper"
    }, props.icon === "error" ? /* @__PURE__ */ import_react4.default.createElement(ErrorIcon, null) : /* @__PURE__ */ import_react4.default.createElement(LibraryIcon, null), /* @__PURE__ */ import_react4.default.createElement("h1", null, props.heading), /* @__PURE__ */ import_react4.default.createElement("h3", null, props.subheading))) : /* @__PURE__ */ import_react4.default.createElement(import_react4.default.Fragment, null);
  };
  var status_default = Status;

  // src/components/inline_grid.tsx
  var import_react5 = __toESM(require_react());
  function scrollGrid(event) {
    const { target } = event;
    if (!(target instanceof HTMLElement))
      return;
    const grid = target.parentNode?.querySelector("div");
    if (!grid)
      return;
    grid.scrollLeft += grid.clientWidth;
    if (grid.scrollWidth - grid.clientWidth - grid.scrollLeft <= grid.clientWidth) {
      grid.setAttribute("data-scroll", "end");
    } else {
      grid.setAttribute("data-scroll", "both");
    }
  }
  function scrollGridLeft(event) {
    const { target } = event;
    if (!(target instanceof HTMLElement))
      return;
    const grid = target.parentNode?.querySelector("div");
    if (!grid)
      return;
    grid.scrollLeft -= grid.clientWidth;
    if (grid.scrollLeft <= grid.clientWidth) {
      grid.setAttribute("data-scroll", "start");
    } else {
      grid.setAttribute("data-scroll", "both");
    }
  }
  function InlineGrid(props) {
    const { children, special } = props;
    return /* @__PURE__ */ import_react5.default.createElement("section", {
      className: "stats-gridInlineSection"
    }, /* @__PURE__ */ import_react5.default.createElement("button", {
      className: "stats-scrollButton",
      onClick: scrollGridLeft
    }, "<"), /* @__PURE__ */ import_react5.default.createElement("button", {
      className: "stats-scrollButton",
      onClick: scrollGrid
    }, ">"), /* @__PURE__ */ import_react5.default.createElement("div", {
      className: `main-gridContainer-gridContainer stats-gridInline${special ? " stats-specialGrid" : ""}`,
      "data-scroll": "start"
    }, children));
  }
  var inline_grid_default = import_react5.default.memo(InlineGrid);

  // src/components/shelf.tsx
  var import_react6 = __toESM(require_react());
  function Shelf(props) {
    const { TextComponent } = Spicetify.ReactComponent;
    const { title, children } = props;
    return /* @__PURE__ */ import_react6.default.createElement("section", {
      className: "main-shelf-shelf Shelf"
    }, /* @__PURE__ */ import_react6.default.createElement("div", {
      className: "main-shelf-header"
    }, /* @__PURE__ */ import_react6.default.createElement("div", {
      className: "main-shelf-topRow"
    }, /* @__PURE__ */ import_react6.default.createElement("div", {
      className: "main-shelf-titleWrapper"
    }, /* @__PURE__ */ import_react6.default.createElement(TextComponent, {
      children: title,
      as: "h2",
      variant: "canon",
      semanticColor: "textBase"
    })))), /* @__PURE__ */ import_react6.default.createElement("section", null, children));
  }
  var shelf_default = import_react6.default.memo(Shelf);

  // src/funcs.ts
  var apiRequest = async (name, url, timeout = 5, log = true) => {
    try {
      const timeStart = window.performance.now();
      const response = await Spicetify.CosmosAsync.get(url);
      if (log)
        console.log("stats -", name, "fetch time:", window.performance.now() - timeStart);
      return response;
    } catch (e) {
      if (timeout === 0) {
        console.log("stats -", name, "all requests failed:", e);
        console.log("stats -", name, "giving up");
        return null;
      } else {
        if (timeout === 5) {
          console.log("stats -", name, "request failed:", e);
          console.log("stats -", name, "retrying...");
        }
        await new Promise((resolve) => setTimeout(resolve, 5e3));
        return apiRequest(name, url, timeout - 1);
      }
    }
  };
  var fetchAudioFeatures = async (ids) => {
    const batchSize = 100;
    const batches = [];
    ids = ids.filter((id) => id.match(/^[a-zA-Z0-9]{22}$/));
    for (let i = 0; i < ids.length; i += batchSize) {
      const batch = ids.slice(i, i + batchSize);
      batches.push(batch);
    }
    const promises = batches.map((batch, index) => {
      const url = `https://api.spotify.com/v1/audio-features?ids=${batch.join(",")}`;
      return apiRequest("audioFeaturesBatch" + index, url, 5, false);
    });
    const responses = await Promise.all(promises);
    const data = responses.reduce((acc, response) => {
      if (!response?.audio_features)
        return acc;
      return acc.concat(response.audio_features);
    }, []);
    return data;
  };
  var fetchTopAlbums = async (albums, cachedAlbums) => {
    let album_keys = Object.keys(albums).filter((id) => id.match(/^[a-zA-Z0-9]{22}$/)).sort((a, b) => albums[b] - albums[a]).slice(0, 100);
    let release_years = {};
    let total_album_tracks = 0;
    let top_albums = await Promise.all(
      album_keys.map(async (albumID) => {
        let albumMeta;
        if (cachedAlbums) {
          for (let i = 0; i < cachedAlbums.length; i++) {
            if (cachedAlbums[i].uri === `spotify:album:${albumID}`) {
              albumMeta = cachedAlbums[i];
              break;
            }
          }
        }
        if (!albumMeta) {
          try {
            albumMeta = await Spicetify.GraphQL.Request(Spicetify.GraphQL.Definitions.getAlbum, {
              uri: `spotify:album:${albumID}`,
              locale: "en",
              offset: 0,
              limit: 50
            });
            if (!albumMeta?.data?.albumUnion?.name)
              throw new Error("Invalid URI");
          } catch (e) {
            console.error("stats - album metadata request failed:", e);
            return;
          }
        }
        const releaseYear = albumMeta?.release_year || albumMeta.data.albumUnion.date.isoString.slice(0, 4);
        release_years[releaseYear] = (release_years[releaseYear] || 0) + albums[albumID];
        total_album_tracks += albums[albumID];
        return {
          name: albumMeta.name || albumMeta.data.albumUnion.name,
          uri: albumMeta.uri || albumMeta.data.albumUnion.uri,
          image: albumMeta.image || albumMeta.data.albumUnion.coverArt.sources[0]?.url || "https://commons.wikimedia.org/wiki/File:Black_square.jpg",
          release_year: releaseYear,
          freq: albums[albumID]
        };
      })
    );
    top_albums = top_albums.filter((el) => el != null).slice(0, 10);
    return [top_albums, Object.entries(release_years), total_album_tracks];
  };
  var fetchTopArtists = async (artists) => {
    if (Object.keys(artists).length === 0)
      return [[], [], 0];
    let artist_keys = Object.keys(artists).filter((id) => id.match(/^[a-zA-Z0-9]{22}$/)).sort((a, b) => artists[b] - artists[a]).slice(0, 50);
    let genres = {};
    let total_genre_tracks = 0;
    const artistsMeta = await apiRequest("artistsMetadata", `https://api.spotify.com/v1/artists?ids=${artist_keys.join(",")}`);
    let top_artists = artistsMeta?.artists?.map((artist) => {
      if (!artist)
        return null;
      artist.genres.forEach((genre) => {
        genres[genre] = (genres[genre] || 0) + artists[artist.id];
      });
      total_genre_tracks += artists[artist.id];
      return {
        name: artist.name,
        uri: artist.uri,
        image: artist.images[2]?.url || "https://commons.wikimedia.org/wiki/File:Black_square.jpg",
        freq: artists[artist.id]
      };
    });
    top_artists = top_artists.filter((el) => el != null).slice(0, 10);
    const top_genres = Object.entries(genres).sort((a, b) => b[1] - a[1]).slice(0, 10);
    return [top_artists, top_genres, total_genre_tracks];
  };

  // src/pages/playlist.tsx
  var PlaylistPage = ({ uri }) => {
    const { ReactComponent, ReactQuery, Platform, _platform } = Spicetify;
    const { History, ReduxStore } = Platform;
    const { QueryClientProvider, QueryClient } = ReactQuery;
    const { Router, Route, Routes, PlatformProvider, StoreProvider } = ReactComponent;
    const [library, setLibrary] = import_react7.default.useState(100);
    const fetchData = async () => {
      const start = window.performance.now();
      const playlistMeta = await apiRequest("playlistMeta", `sp://core-playlist/v1/playlist/${uri}`);
      if (!playlistMeta) {
        setLibrary(200);
        return;
      }
      let duration = playlistMeta.playlist.duration;
      let trackCount = playlistMeta.playlist.length;
      let explicitCount = 0;
      let trackIDs = [];
      let popularity = 0;
      let albums = {};
      let artists = {};
      playlistMeta.items.forEach((track) => {
        popularity += track.popularity;
        trackIDs.push(track.link.split(":")[2]);
        if (track.isExplicit)
          explicitCount++;
        const albumID = track.album.link.split(":")[2];
        albums[albumID] = albums[albumID] ? albums[albumID] + 1 : 1;
        track.artists.forEach((artist) => {
          const artistID = artist.link.split(":")[2];
          artists[artistID] = artists[artistID] ? artists[artistID] + 1 : 1;
        });
      });
      const [topAlbums, releaseYears, releaseYearsTotal] = await fetchTopAlbums(albums);
      const [topArtists, topGenres, topGenresTotal] = await fetchTopArtists(artists);
      const fetchedFeatures = await fetchAudioFeatures(trackIDs);
      let audioFeatures = {
        danceability: 0,
        energy: 0,
        valence: 0,
        speechiness: 0,
        acousticness: 0,
        instrumentalness: 0,
        liveness: 0,
        tempo: 0
      };
      for (let i = 0; i < fetchedFeatures.length; i++) {
        if (!fetchedFeatures[i])
          continue;
        const track = fetchedFeatures[i];
        Object.keys(audioFeatures).forEach((feature) => {
          audioFeatures[feature] += track[feature];
        });
      }
      audioFeatures = { popularity, explicitness: explicitCount, ...audioFeatures };
      for (let key in audioFeatures) {
        audioFeatures[key] /= fetchedFeatures.length;
      }
      const stats2 = {
        audioFeatures,
        trackCount,
        totalDuration: duration,
        artistCount: Object.keys(artists).length,
        artists: topArtists,
        genres: topGenres,
        genresDenominator: topGenresTotal,
        albums: topAlbums,
        years: releaseYears,
        yearsDenominator: releaseYearsTotal
      };
      setLibrary(stats2);
      console.log("total playlist stats fetch time:", window.performance.now() - start);
    };
    import_react7.default.useEffect(() => {
      fetchData();
    }, []);
    switch (library) {
      case 200:
        return /* @__PURE__ */ import_react7.default.createElement(status_default, {
          icon: "error",
          heading: "Failed to Fetch Stats",
          subheading: "Make an issue on Github"
        });
      case 100:
        return /* @__PURE__ */ import_react7.default.createElement(status_default, {
          icon: "library",
          heading: "Analysing the Playlist",
          subheading: "This may take a while"
        });
    }
    const statCards = Object.entries(library.audioFeatures).map(([key, value]) => {
      return /* @__PURE__ */ import_react7.default.createElement(stat_card_default, {
        label: key,
        value
      });
    });
    const artistCards = library.artists.map((artist) => {
      return /* @__PURE__ */ import_react7.default.createElement(spotify_card_default, {
        type: "artist",
        uri: artist.uri,
        header: artist.name,
        subheader: `Appears in ${artist.freq} tracks`,
        imageUrl: artist.image
      });
    });
    const albumCards = library.albums.map((album) => {
      return /* @__PURE__ */ import_react7.default.createElement(spotify_card_default, {
        type: "album",
        uri: album.uri,
        header: album.name,
        subheader: `Appears in ${album.freq} tracks`,
        imageUrl: album.image
      });
    });
    return /* @__PURE__ */ import_react7.default.createElement(QueryClientProvider, {
      client: new QueryClient()
    }, /* @__PURE__ */ import_react7.default.createElement(Router, {
      location: {
        pathname: "/"
      },
      navigator: History
    }, /* @__PURE__ */ import_react7.default.createElement(StoreProvider, {
      store: ReduxStore
    }, /* @__PURE__ */ import_react7.default.createElement(PlatformProvider, {
      platform: _platform
    }, /* @__PURE__ */ import_react7.default.createElement(Routes, null, /* @__PURE__ */ import_react7.default.createElement(Route, {
      path: "/",
      element: /* @__PURE__ */ import_react7.default.createElement("div", {
        className: "stats-page encore-dark-theme encore-base-set"
      }, /* @__PURE__ */ import_react7.default.createElement("section", {
        className: "stats-libraryOverview"
      }, /* @__PURE__ */ import_react7.default.createElement(stat_card_default, {
        label: "Total Tracks",
        value: library.trackCount.toString()
      }), /* @__PURE__ */ import_react7.default.createElement(stat_card_default, {
        label: "Total Artists",
        value: library.artistCount.toString()
      }), /* @__PURE__ */ import_react7.default.createElement(stat_card_default, {
        label: "Total Minutes",
        value: Math.floor(library.totalDuration / 60).toString()
      }), /* @__PURE__ */ import_react7.default.createElement(stat_card_default, {
        label: "Total Hours",
        value: (library.totalDuration / (60 * 60)).toFixed(1)
      })), /* @__PURE__ */ import_react7.default.createElement(shelf_default, {
        title: "Most Frequent Genres"
      }, /* @__PURE__ */ import_react7.default.createElement(genres_card_default, {
        genres: library.genres,
        total: library.genresDenominator
      }), /* @__PURE__ */ import_react7.default.createElement(inline_grid_default, {
        special: true
      }, statCards)), /* @__PURE__ */ import_react7.default.createElement(shelf_default, {
        title: "Most Frequent Artists"
      }, /* @__PURE__ */ import_react7.default.createElement(inline_grid_default, null, artistCards)), /* @__PURE__ */ import_react7.default.createElement(shelf_default, {
        title: "Most Frequent Albums"
      }, /* @__PURE__ */ import_react7.default.createElement(inline_grid_default, null, albumCards)), /* @__PURE__ */ import_react7.default.createElement(shelf_default, {
        title: "Release Year Distribution"
      }, /* @__PURE__ */ import_react7.default.createElement(genres_card_default, {
        genres: library.years,
        total: library.yearsDenominator
      })))
    }))))));
  };
  var playlist_default = import_react7.default.memo(PlaylistPage);

  // package.json
  var version = "0.3.1";

  // src/constants.ts
  var STATS_VERSION = version;

  // src/extensions/extension.tsx
  (function stats() {
    const { PopupModal, LocalStorage, Topbar, Platform: { History } } = Spicetify;
    if (!PopupModal || !LocalStorage || !Topbar || !History) {
      setTimeout(stats, 300);
      return;
    }
    const version2 = localStorage.getItem("stats:version");
    if (!version2 || version2 !== STATS_VERSION) {
      for (let i = 0; i < localStorage.length; i++) {
        const key = localStorage.key(i);
        if (key.startsWith("stats:") && !key.startsWith("stats:config:")) {
          localStorage.removeItem(key);
        }
      }
      localStorage.setItem("stats:version", STATS_VERSION);
    }
    LocalStorage.set("stats:cache-info", JSON.stringify([0, 0, 0, 0, 0, 0]));
    const styleLink = document.createElement("link");
    styleLink.rel = "stylesheet";
    styleLink.href = "/spicetify-routes-stats.css";
    document.head.appendChild(styleLink);
    const playlistEdit = new Topbar.Button("playlist-stats", "visualizer", () => {
      const playlistUri = `spotify:playlist:${History.location.pathname.split("/")[2]}`;
      PopupModal.display({ title: "Playlist Stats", content: /* @__PURE__ */ import_react8.default.createElement(playlist_default, {
        uri: playlistUri
      }), isLarge: true });
    });
    playlistEdit.element.classList.toggle("hidden", true);
    function setTopbarButtonVisibility(pathname) {
      const [, type, uid] = pathname.split("/");
      const isPlaylistPage = type === "playlist" && uid;
      playlistEdit.element.classList.toggle("hidden", !isPlaylistPage);
    }
    setTopbarButtonVisibility(History.location.pathname);
    History.listen(({ pathname }) => {
      setTopbarButtonVisibility(pathname);
    });
  })();
})();

        })();