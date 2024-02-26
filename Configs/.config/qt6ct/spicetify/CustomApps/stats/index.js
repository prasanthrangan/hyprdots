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
  var __export = (target, all) => {
    for (var name in all)
      __defProp(target, name, { get: all[name], enumerable: true });
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
  var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);

  // external-global-plugin:react
  var require_react = __commonJS({
    "external-global-plugin:react"(exports, module) {
      module.exports = Spicetify.React;
    }
  });

  // external-global-plugin:react-dom
  var require_react_dom = __commonJS({
    "external-global-plugin:react-dom"(exports, module) {
      module.exports = Spicetify.ReactDOM;
    }
  });

  // node_modules/spicetify-creator/dist/temp/index.jsx
  var temp_exports = {};
  __export(temp_exports, {
    default: () => render
  });

  // src/app.tsx
  var import_react26 = __toESM(require_react());

  // node_modules/spcr-navigation-bar/useNavigationBar.tsx
  var import_react3 = __toESM(require_react());

  // node_modules/spcr-navigation-bar/navBar.tsx
  var import_react2 = __toESM(require_react());
  var import_react_dom = __toESM(require_react_dom());

  // node_modules/spcr-navigation-bar/optionsMenu.tsx
  var import_react = __toESM(require_react());
  var OptionsMenuItemIcon = /* @__PURE__ */ import_react.default.createElement("svg", {
    width: 16,
    height: 16,
    viewBox: "0 0 16 16",
    fill: "currentColor"
  }, /* @__PURE__ */ import_react.default.createElement("path", {
    d: "M13.985 2.383L5.127 12.754 1.388 8.375l-.658.77 4.397 5.149 9.618-11.262z"
  }));
  var OptionsMenuItem = import_react.default.memo((props) => {
    return /* @__PURE__ */ import_react.default.createElement(Spicetify.ReactComponent.MenuItem, {
      onClick: props.onSelect,
      icon: props.isSelected ? OptionsMenuItemIcon : null
    }, props.value);
  });
  var OptionsMenu = import_react.default.memo((props) => {
    const menuRef = import_react.default.useRef(null);
    const menu = /* @__PURE__ */ import_react.default.createElement(Spicetify.ReactComponent.Menu, null, props.options.map(
      (option) => /* @__PURE__ */ import_react.default.createElement(OptionsMenuItem, {
        value: option.link,
        isSelected: option.isActive,
        onSelect: () => {
          props.onSelect(option.link);
          menuRef.current?.click();
        }
      })
    ));
    return /* @__PURE__ */ import_react.default.createElement(Spicetify.ReactComponent.ContextMenu, {
      menu,
      trigger: "click",
      action: "toggle",
      renderInLine: true
    }, /* @__PURE__ */ import_react.default.createElement("button", {
      className: navBar_module_default.optionsMenuDropBox,
      ref: menuRef
    }, /* @__PURE__ */ import_react.default.createElement("span", {
      className: props.bold ? "main-type-mestoBold" : "main-type-mesto"
    }, props.options.find((o) => o.isActive)?.link || props.defaultValue), /* @__PURE__ */ import_react.default.createElement("svg", {
      width: 16,
      height: 16,
      viewBox: "0 0 16 16",
      fill: "currentColor"
    }, /* @__PURE__ */ import_react.default.createElement("path", {
      d: "M3 6l5 5.794L13 6z"
    }))));
  });
  var optionsMenu_default = OptionsMenu;

  // postcss-module:C:\Users\user\AppData\Local\Temp\tmp-11964-wBAOqZhOo4po\18d07cb0fbf2\navBar.module.css
  var navBar_module_default = { "topBarHeaderItem": "navBar-module__topBarHeaderItem___v29bR_stats", "topBarHeaderItemLink": "navBar-module__topBarHeaderItemLink___VeyBY_stats", "topBarActive": "navBar-module__topBarActive___-qYPu_stats", "topBarNav": "navBar-module__topBarNav___1OtdR_stats", "optionsMenuDropBox": "navBar-module__optionsMenuDropBox___tD9mA_stats" };

  // node_modules/spcr-navigation-bar/navBar.tsx
  var NavbarItem2 = class {
    constructor(link, isActive) {
      this.link = link;
      this.isActive = isActive;
    }
  };
  var NavbarItemComponent = (props) => {
    return /* @__PURE__ */ import_react2.default.createElement("li", {
      className: navBar_module_default.topBarHeaderItem,
      onClick: (e) => {
        e.preventDefault();
        props.switchTo(props.item.link);
      }
    }, /* @__PURE__ */ import_react2.default.createElement("a", {
      className: `${navBar_module_default.topBarHeaderItemLink} queue-tabBar-headerItemLink ${props.item.isActive ? navBar_module_default.topBarActive + " queue-tabBar-active" : ""}`,
      "aria-current": "page",
      draggable: false,
      href: ""
    }, /* @__PURE__ */ import_react2.default.createElement("span", {
      className: "main-type-mestoBold"
    }, props.item.link)));
  };
  var NavbarMore = import_react2.default.memo(({ items, switchTo }) => {
    return /* @__PURE__ */ import_react2.default.createElement("li", {
      className: `${navBar_module_default.topBarHeaderItem} ${items.find((item) => item.isActive) ? navBar_module_default.topBarActive : ""}`
    }, /* @__PURE__ */ import_react2.default.createElement(optionsMenu_default, {
      options: items,
      onSelect: switchTo,
      defaultValue: "More",
      bold: true
    }));
  });
  var NavbarContent = (props) => {
    const resizeHost = document.querySelector(".Root__main-view .os-resize-observer-host");
    const [windowSize, setWindowSize] = (0, import_react2.useState)(resizeHost.clientWidth);
    const resizeHandler = () => setWindowSize(resizeHost.clientWidth);
    (0, import_react2.useEffect)(() => {
      const observer = new ResizeObserver(resizeHandler);
      observer.observe(resizeHost);
      return () => {
        observer.disconnect();
      };
    }, [resizeHandler]);
    return /* @__PURE__ */ import_react2.default.createElement(NavbarContext, null, /* @__PURE__ */ import_react2.default.createElement(Navbar, {
      ...props,
      windowSize
    }));
  };
  var NavbarContext = (props) => {
    return import_react_dom.default.createPortal(
      /* @__PURE__ */ import_react2.default.createElement("div", {
        className: "main-topbar-topbarContent"
      }, props.children),
      document.querySelector(".main-topBar-topbarContentWrapper")
    );
  };
  var Navbar = (props) => {
    const navBarListRef = import_react2.default.useRef(null);
    const [childrenSizes, setChildrenSizes] = (0, import_react2.useState)([]);
    const [availableSpace, setAvailableSpace] = (0, import_react2.useState)(0);
    const [outOfRangeItemIndexes, setOutOfRangeItemIndexes] = (0, import_react2.useState)([]);
    let items = props.links.map((link) => new NavbarItem2(link, link === props.activeLink));
    (0, import_react2.useEffect)(() => {
      if (!navBarListRef.current)
        return;
      const children = Array.from(navBarListRef.current.children);
      const navBarItemSizes = children.map((child) => child.clientWidth);
      setChildrenSizes(navBarItemSizes);
    }, []);
    (0, import_react2.useEffect)(() => {
      if (!navBarListRef.current)
        return;
      setAvailableSpace(navBarListRef.current.clientWidth);
    }, [props.windowSize]);
    (0, import_react2.useEffect)(() => {
      if (!navBarListRef.current)
        return;
      let totalSize = childrenSizes.reduce((a, b) => a + b, 0);
      if (totalSize <= availableSpace) {
        setOutOfRangeItemIndexes([]);
        return;
      }
      const viewMoreButtonSize = Math.max(...childrenSizes);
      const itemsToHide = [];
      let stopWidth = viewMoreButtonSize;
      childrenSizes.forEach((childWidth, i) => {
        if (availableSpace >= stopWidth + childWidth) {
          stopWidth += childWidth;
        } else if (i !== items.length) {
          itemsToHide.push(i);
        }
      });
      setOutOfRangeItemIndexes(itemsToHide);
    }, [availableSpace, childrenSizes]);
    return /* @__PURE__ */ import_react2.default.createElement("nav", {
      className: navBar_module_default.topBarNav
    }, /* @__PURE__ */ import_react2.default.createElement("ul", {
      className: navBar_module_default.topBarHeader + " queue-tabBar-header",
      ref: navBarListRef
    }, items.filter((_, id) => !outOfRangeItemIndexes.includes(id)).map(
      (item) => /* @__PURE__ */ import_react2.default.createElement(NavbarItemComponent, {
        item,
        switchTo: props.switchCallback
      })
    ), outOfRangeItemIndexes.length ? /* @__PURE__ */ import_react2.default.createElement(NavbarMore, {
      items: outOfRangeItemIndexes.map((i) => items[i]),
      switchTo: props.switchCallback
    }) : null));
  };
  var navBar_default = NavbarContent;

  // node_modules/spcr-navigation-bar/useNavigationBar.tsx
  var useNavigationBar = (links) => {
    const [activeLink, setActiveLink] = (0, import_react3.useState)(links[0]);
    const navbar = /* @__PURE__ */ import_react3.default.createElement(navBar_default, {
      links,
      activeLink,
      switchCallback: (link) => setActiveLink(link)
    });
    return [navbar, activeLink, setActiveLink];
  };
  var useNavigationBar_default = useNavigationBar;

  // src/pages/top_artists.tsx
  var import_react12 = __toESM(require_react());

  // src/components/hooks/useDropdownMenu.tsx
  var import_react5 = __toESM(require_react());

  // src/components/dropdown.tsx
  var import_react4 = __toESM(require_react());
  function CheckIcon() {
    return /* @__PURE__ */ import_react4.default.createElement(Spicetify.ReactComponent.IconComponent, {
      iconSize: "16",
      semanticColor: "textBase",
      dangerouslySetInnerHTML: { __html: '<svg xmlns="http://www.w3.org/2000/svg"><path d="M15.53 2.47a.75.75 0 0 1 0 1.06L4.907 14.153.47 9.716a.75.75 0 0 1 1.06-1.06l3.377 3.376L14.47 2.47a.75.75 0 0 1 1.06 0z"/></svg>' }
    });
  }
  var MenuItem = (props) => {
    const { ReactComponent } = Spicetify;
    const { option, isActive, switchCallback } = props;
    const activeStyle = {
      backgroundColor: "rgba(var(--spice-rgb-selected-row),.1)"
    };
    return /* @__PURE__ */ import_react4.default.createElement(ReactComponent.MenuItem, {
      trigger: "click",
      onClick: () => switchCallback(option),
      "data-checked": isActive,
      trailingIcon: isActive ? /* @__PURE__ */ import_react4.default.createElement(CheckIcon, null) : void 0,
      style: isActive ? activeStyle : void 0
    }, option);
  };
  var DropdownMenu = (props) => {
    const { ContextMenu, Menu, IconComponent, TextComponent } = Spicetify.ReactComponent;
    const { options, activeOption, switchCallback } = props;
    const optionItems = options.map((option) => {
      return /* @__PURE__ */ import_react4.default.createElement(MenuItem, {
        option,
        isActive: option === activeOption,
        switchCallback
      });
    });
    const MenuWrapper2 = (props2) => {
      return /* @__PURE__ */ import_react4.default.createElement(Menu, {
        ...props2
      }, optionItems);
    };
    return /* @__PURE__ */ import_react4.default.createElement(ContextMenu, {
      menu: /* @__PURE__ */ import_react4.default.createElement(MenuWrapper2, null),
      trigger: "click"
    }, /* @__PURE__ */ import_react4.default.createElement("button", {
      className: "x-sortBox-sortDropdown",
      type: "button",
      role: "combobox",
      "aria-expanded": "false"
    }, /* @__PURE__ */ import_react4.default.createElement(TextComponent, {
      variant: "mesto",
      semanticColor: "textSubdued"
    }, activeOption), /* @__PURE__ */ import_react4.default.createElement("svg", {
      role: "img",
      height: "16",
      width: "16",
      "aria-hidden": "true",
      className: "Svg-img-16 Svg-img-16-icon Svg-img-icon Svg-img-icon-small",
      viewBox: "0 0 16 16",
      "data-encore-id": "icon"
    }, /* @__PURE__ */ import_react4.default.createElement("path", {
      d: "m14 6-6 6-6-6h12z"
    }))));
  };
  var dropdown_default = DropdownMenu;

  // src/components/hooks/useDropdownMenu.tsx
  var useDropdownMenu = (options, displayOptions, storageVariable) => {
    const initialOption = Spicetify.LocalStorage.get(`stats:${storageVariable}:active-option`);
    const [activeOption, setActiveOption] = (0, import_react5.useState)(initialOption || options[0]);
    const dropdown = /* @__PURE__ */ import_react5.default.createElement(dropdown_default, {
      options: displayOptions,
      activeOption: displayOptions[options.indexOf(activeOption)],
      switchCallback: (option) => {
        setActiveOption(options[displayOptions.indexOf(option)]);
        Spicetify.LocalStorage.set(`stats:${storageVariable}:active-option`, options[displayOptions.indexOf(option)]);
      }
    });
    return [dropdown, activeOption, setActiveOption];
  };
  var useDropdownMenu_default = useDropdownMenu;

  // src/components/cards/spotify_card.tsx
  var import_react6 = __toESM(require_react());
  function SpotifyCard(props) {
    const { Cards, TextComponent, ArtistMenu, AlbumMenu, ContextMenu } = Spicetify.ReactComponent;
    const { Default: Card, CardImage } = Cards;
    const { type, header, uri, imageUrl, subheader } = props;
    const Menu = () => {
      switch (type) {
        case "artist":
          return /* @__PURE__ */ import_react6.default.createElement(ArtistMenu, {
            uri
          });
        case "album":
          return /* @__PURE__ */ import_react6.default.createElement(AlbumMenu, {
            uri
          });
        default:
          return /* @__PURE__ */ import_react6.default.createElement(import_react6.default.Fragment, null);
      }
    };
    const lastfmProps = type === "lastfm" ? { onClick: () => window.open(uri, "_blank"), isPlayable: false, delegateNavigation: true } : {};
    return /* @__PURE__ */ import_react6.default.createElement(ContextMenu, {
      menu: /* @__PURE__ */ import_react6.default.createElement(Menu, null),
      trigger: "right-click"
    }, /* @__PURE__ */ import_react6.default.createElement(Card, {
      featureIdentifier: type,
      headerText: header,
      renderCardImage: () => /* @__PURE__ */ import_react6.default.createElement(CardImage, {
        images: [{
          height: 640,
          url: imageUrl,
          width: 640
        }],
        isCircular: type === "artist"
      }),
      renderSubHeaderContent: () => /* @__PURE__ */ import_react6.default.createElement(TextComponent, {
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

  // src/funcs.ts
  var updatePageCache = (i, callback, activeOption, lib = false) => {
    let cacheInfo = Spicetify.LocalStorage.get("stats:cache-info");
    if (!cacheInfo)
      return;
    let cacheInfoArray = JSON.parse(cacheInfo);
    if (!cacheInfoArray[i]) {
      if (!lib) {
        ["short_term", "medium_term", "long_term"].filter((option) => option !== activeOption).forEach((option) => callback(option, true, false));
      }
      if (lib === "charts") {
        ["artists", "tracks"].filter((option) => option !== activeOption).forEach((option) => callback(option, true, false));
      }
      callback(activeOption, true);
      cacheInfoArray[i] = true;
      Spicetify.LocalStorage.set("stats:cache-info", JSON.stringify(cacheInfoArray));
    }
  };
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
  function filterLink(str) {
    const normalizedStr = str.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
    return normalizedStr.replace(/[^a-zA-Z0-9\-._~:/?#[\]@!$&()*+,;= ]/g, "").replace(/ /g, "+");
  }
  var convertToSpotify = async (data, type) => {
    return await Promise.all(
      data.map(async (item) => {
        if (type === "artists") {
          const spotifyItem2 = await Spicetify.CosmosAsync.get(`https://api.spotify.com/v1/search?q=${filterLink(item.name)}&type=artist`).then(
            (res) => res.artists?.items[0]
          );
          if (!spotifyItem2) {
            console.log(`https://api.spotify.com/v1/search?q=${filterLink(item.name)}&type=artist`);
            return {
              name: item.name,
              image: item.image[0]["#text"],
              uri: item.url,
              id: item.mbid
            };
          }
          return {
            name: item.name,
            image: spotifyItem2.images[0].url,
            uri: spotifyItem2.uri,
            id: spotifyItem2.id,
            genres: spotifyItem2.genres
          };
        }
        if (type === "albums") {
          const spotifyItem2 = await Spicetify.CosmosAsync.get(
            `https://api.spotify.com/v1/search?q=${filterLink(item.name)}+artist:${filterLink(item.artist.name)}&type=album`
          ).then((res) => res.albums?.items[0]);
          if (!spotifyItem2) {
            console.log(`https://api.spotify.com/v1/search?q=${filterLink(item.name)}+artist:${filterLink(item.artist.name)}&type=album`);
            return {
              name: item.name,
              image: item.image[2]["#text"],
              uri: item.url,
              id: item.mbid
            };
          }
          return {
            name: item.name,
            image: spotifyItem2.images[0].url,
            uri: spotifyItem2.uri,
            id: spotifyItem2.id
          };
        }
        const spotifyItem = await Spicetify.CosmosAsync.get(
          `https://api.spotify.com/v1/search?q=track:${filterLink(item.name)}+artist:${filterLink(item.artist.name)}&type=track`
        ).then((res) => res.tracks?.items[0]);
        if (!spotifyItem) {
          console.log(`https://api.spotify.com/v1/search?q=track:${filterLink(item.name)}+artist:${filterLink(item.artist.name)}&type=track`);
          return {
            name: item.name,
            image: item.image[0]["#text"],
            uri: item.url,
            artists: [{ name: item.artist.name, uri: item.artist.url }],
            duration: 0,
            album: "N/A",
            popularity: 0,
            explicit: false,
            album_uri: item.url
          };
        }
        return {
          name: item.name,
          image: spotifyItem.album.images[0].url,
          uri: spotifyItem.uri,
          id: spotifyItem.id,
          artists: spotifyItem.artists.map((artist) => ({ name: artist.name, uri: artist.uri })),
          duration: spotifyItem.duration_ms,
          album: spotifyItem.album.name,
          popularity: spotifyItem.popularity,
          explicit: spotifyItem.explicit,
          album_uri: spotifyItem.album.uri,
          release_year: spotifyItem.album.release_date.slice(0, 4)
        };
      })
    );
  };
  var checkLiked = async (tracks) => {
    const nullIndexes = [];
    tracks.forEach((track, index) => {
      if (track === null) {
        nullIndexes.push(index);
      }
    });
    const apiResponse = await apiRequest("checkLiked", `https://api.spotify.com/v1/me/tracks/contains?ids=${tracks.filter((e) => e).join(",")}`);
    const response = [];
    let nullIndexesIndex = 0;
    for (let i = 0; i < tracks.length; i++) {
      if (nullIndexes.includes(i)) {
        response.push(false);
      } else {
        response.push(apiResponse[nullIndexesIndex]);
        nullIndexesIndex++;
      }
    }
    return response;
  };
  async function queue(list, context = null) {
    list.push("spotify:delimiter");
    const { _queue, _client } = Spicetify.Platform.PlayerAPI._queue;
    const { prevTracks, queueRevision } = _queue;
    const nextTracks = list.map((uri) => ({
      contextTrack: {
        uri,
        uid: "",
        metadata: {
          is_queued: "false"
        }
      },
      removed: [],
      blocked: [],
      provider: "context"
    }));
    _client.setQueue({
      nextTracks,
      prevTracks,
      queueRevision
    });
    if (context) {
      const { sessionId } = Spicetify.Platform.PlayerAPI.getState();
      Spicetify.Platform.PlayerAPI.updateContext(sessionId, { uri: `spotify:user:${Spicetify.Platform.LibraryAPI._currentUsername}:top:tracks`, url: "" });
    }
    Spicetify.Player.next();
  }

  // src/components/status.tsx
  var import_react7 = __toESM(require_react());
  var ErrorIcon = () => {
    return /* @__PURE__ */ import_react7.default.createElement("svg", {
      "data-encore-id": "icon",
      role: "img",
      "aria-hidden": "true",
      viewBox: "0 0 24 24",
      className: "status-icon"
    }, /* @__PURE__ */ import_react7.default.createElement("path", {
      d: "M11 18v-2h2v2h-2zm0-4V6h2v8h-2z"
    }), /* @__PURE__ */ import_react7.default.createElement("path", {
      d: "M12 3a9 9 0 1 0 0 18 9 9 0 0 0 0-18zM1 12C1 5.925 5.925 1 12 1s11 4.925 11 11-4.925 11-11 11S1 18.075 1 12z"
    }));
  };
  var LibraryIcon = () => {
    return /* @__PURE__ */ import_react7.default.createElement("svg", {
      role: "img",
      height: "46",
      width: "46",
      "aria-hidden": "true",
      viewBox: "0 0 24 24",
      "data-encore-id": "icon",
      className: "status-icon"
    }, /* @__PURE__ */ import_react7.default.createElement("path", {
      d: "M14.5 2.134a1 1 0 0 1 1 0l6 3.464a1 1 0 0 1 .5.866V21a1 1 0 0 1-1 1h-6a1 1 0 0 1-1-1V3a1 1 0 0 1 .5-.866zM16 4.732V20h4V7.041l-4-2.309zM3 22a1 1 0 0 1-1-1V3a1 1 0 0 1 2 0v18a1 1 0 0 1-1 1zm6 0a1 1 0 0 1-1-1V3a1 1 0 0 1 2 0v18a1 1 0 0 1-1 1z"
    }));
  };
  var Status = (props) => {
    const [isVisible, setIsVisible] = import_react7.default.useState(false);
    import_react7.default.useEffect(() => {
      const to = setTimeout(() => {
        setIsVisible(true);
      }, 500);
      return () => clearTimeout(to);
    }, []);
    return isVisible ? /* @__PURE__ */ import_react7.default.createElement(import_react7.default.Fragment, null, /* @__PURE__ */ import_react7.default.createElement("div", {
      className: "stats-loadingWrapper"
    }, props.icon === "error" ? /* @__PURE__ */ import_react7.default.createElement(ErrorIcon, null) : /* @__PURE__ */ import_react7.default.createElement(LibraryIcon, null), /* @__PURE__ */ import_react7.default.createElement("h1", null, props.heading), /* @__PURE__ */ import_react7.default.createElement("h3", null, props.subheading))) : /* @__PURE__ */ import_react7.default.createElement(import_react7.default.Fragment, null);
  };
  var status_default = Status;

  // src/components/page_container.tsx
  var import_react11 = __toESM(require_react());

  // src/components/buttons/refresh_button.tsx
  var import_react8 = __toESM(require_react());
  function RefreshIcon() {
    return /* @__PURE__ */ import_react8.default.createElement(Spicetify.ReactComponent.IconComponent, {
      semanticColor: "textSubdued",
      iconSize: "16",
      dangerouslySetInnerHTML: { __html: '<svg xmlns="http://www.w3.org/2000/svg"><path d="M0 4.75A3.75 3.75 0 0 1 3.75 1h8.5A3.75 3.75 0 0 1 16 4.75v5a3.75 3.75 0 0 1-3.75 3.75H9.81l1.018 1.018a.75.75 0 1 1-1.06 1.06L6.939 12.75l2.829-2.828a.75.75 0 1 1 1.06 1.06L9.811 12h2.439a2.25 2.25 0 0 0 2.25-2.25v-5a2.25 2.25 0 0 0-2.25-2.25h-8.5A2.25 2.25 0 0 0 1.5 4.75v5A2.25 2.25 0 0 0 3.75 12H5v1.5H3.75A3.75 3.75 0 0 1 0 9.75v-5z"/></svg>' }
    });
  }
  function RefreshButton(props) {
    const { ButtonTertiary, TooltipWrapper } = Spicetify.ReactComponent;
    const { callback } = props;
    return /* @__PURE__ */ import_react8.default.createElement(TooltipWrapper, {
      label: "Refresh",
      renderInline: true,
      placement: "top"
    }, /* @__PURE__ */ import_react8.default.createElement(ButtonTertiary, {
      buttonSize: "sm",
      onClick: callback,
      "aria-label": "Refresh",
      iconOnly: RefreshIcon
    }));
  }
  var refresh_button_default = RefreshButton;

  // src/components/buttons/settings_button.tsx
  var import_react9 = __toESM(require_react());
  function SettingsIcon() {
    return /* @__PURE__ */ import_react9.default.createElement(Spicetify.ReactComponent.IconComponent, {
      semanticColor: "textSubdued",
      dangerouslySetInnerHTML: { __html: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M24 13.616v-3.232c-1.651-.587-2.694-.752-3.219-2.019v-.001c-.527-1.271.1-2.134.847-3.707l-2.285-2.285c-1.561.742-2.433 1.375-3.707.847h-.001c-1.269-.526-1.435-1.576-2.019-3.219h-3.232c-.582 1.635-.749 2.692-2.019 3.219h-.001c-1.271.528-2.132-.098-3.707-.847l-2.285 2.285c.745 1.568 1.375 2.434.847 3.707-.527 1.271-1.584 1.438-3.219 2.02v3.232c1.632.58 2.692.749 3.219 2.019.53 1.282-.114 2.166-.847 3.707l2.285 2.286c1.562-.743 2.434-1.375 3.707-.847h.001c1.27.526 1.436 1.579 2.019 3.219h3.232c.582-1.636.75-2.69 2.027-3.222h.001c1.262-.524 2.12.101 3.698.851l2.285-2.286c-.744-1.563-1.375-2.433-.848-3.706.527-1.271 1.588-1.44 3.221-2.021zm-12 2.384c-2.209 0-4-1.791-4-4s1.791-4 4-4 4 1.791 4 4-1.791 4-4 4z"/></svg>' },
      iconSize: "16"
    });
  }
  function SettingsButton(props) {
    const { TooltipWrapper, ButtonTertiary } = Spicetify.ReactComponent;
    const { config } = props;
    return /* @__PURE__ */ import_react9.default.createElement(TooltipWrapper, {
      label: "Settings",
      renderInline: true,
      placement: "top"
    }, /* @__PURE__ */ import_react9.default.createElement(ButtonTertiary, {
      buttonSize: "sm",
      onClick: config.launchModal,
      "aria-label": "Settings",
      iconOnly: SettingsIcon
    }));
  }
  var settings_button_default = SettingsButton;

  // src/components/buttons/create_playlist_button.tsx
  var import_react10 = __toESM(require_react());
  async function createPlaylistAsync(infoToCreatePlaylist) {
    const { Platform, showNotification } = Spicetify;
    const { RootlistAPI, PlaylistAPI } = Platform;
    try {
      const { playlistName, itemsUris } = infoToCreatePlaylist;
      const playlistUri = await RootlistAPI.createPlaylist(playlistName, { before: "start" });
      await PlaylistAPI.add(playlistUri, itemsUris, { before: "start" });
    } catch (error) {
      console.error(error);
      showNotification("Failed to create playlist", true, 1e3);
    }
  }
  function CreatePlaylistButton(props) {
    const { TooltipWrapper, ButtonSecondary } = Spicetify.ReactComponent;
    const { infoToCreatePlaylist } = props;
    return /* @__PURE__ */ import_react10.default.createElement(TooltipWrapper, {
      label: "Turn Into Playlist",
      renderInline: true,
      placement: "top"
    }, /* @__PURE__ */ import_react10.default.createElement(ButtonSecondary, {
      "aria-label": "Turn Into Playlist",
      children: "Turn Into Playlist",
      semanticColor: "textBase",
      buttonSize: "sm",
      onClick: () => createPlaylistAsync(infoToCreatePlaylist),
      className: "stats-make-playlist-button"
    }));
  }
  var create_playlist_button_default = CreatePlaylistButton;

  // src/components/page_container.tsx
  function PageContainer(props) {
    const { TextComponent } = Spicetify.ReactComponent;
    const { title, refreshCallback, config, dropdown, infoToCreatePlaylist, children } = props;
    return /* @__PURE__ */ import_react11.default.createElement("section", {
      className: "contentSpacing"
    }, /* @__PURE__ */ import_react11.default.createElement("div", {
      className: "stats-header"
    }, /* @__PURE__ */ import_react11.default.createElement("div", {
      className: "stats-header-left"
    }, /* @__PURE__ */ import_react11.default.createElement(TextComponent, {
      children: title,
      as: "h1",
      variant: "canon",
      semanticColor: "textBase"
    }), infoToCreatePlaylist ? /* @__PURE__ */ import_react11.default.createElement(create_playlist_button_default, {
      infoToCreatePlaylist
    }) : null), /* @__PURE__ */ import_react11.default.createElement("div", {
      className: "stats-header-right"
    }, /* @__PURE__ */ import_react11.default.createElement(refresh_button_default, {
      callback: refreshCallback
    }), /* @__PURE__ */ import_react11.default.createElement(settings_button_default, {
      config
    }), dropdown)), /* @__PURE__ */ import_react11.default.createElement("div", null, children));
  }
  var page_container_default = import_react11.default.memo(PageContainer);

  // src/pages/top_artists.tsx
  var topArtistsReq = async (time_range, config) => {
    if (config.CONFIG["use-lastfm"] === true) {
      if (!config.CONFIG["api-key"] || !config.CONFIG["lastfm-user"]) {
        return 300;
      }
      const lastfmperiods = {
        short_term: "1month",
        medium_term: "6month",
        long_term: "overall"
      };
      const response = await apiRequest(
        "lastfm",
        `https://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=${config.CONFIG["lastfm-user"]}&api_key=${config.CONFIG["api-key"]}&format=json&period=${lastfmperiods[time_range]}`
      );
      if (!response) {
        return 200;
      }
      return await convertToSpotify(response.topartists.artist, "artists");
    } else {
      const response = await apiRequest("topArtists", `https://api.spotify.com/v1/me/top/artists?limit=50&offset=0&time_range=${time_range}`);
      if (!response) {
        return 200;
      }
      return response.items.map((artist) => {
        return {
          id: artist.id,
          name: artist.name,
          image: artist.images[2] ? artist.images[2].url : artist.images[1] ? artist.images[1].url : "https://images.squarespace-cdn.com/content/v1/55fc0004e4b069a519961e2d/1442590746571-RPGKIXWGOO671REUNMCB/image-asset.gif",
          uri: artist.uri,
          genres: artist.genres
        };
      });
    }
  };
  var ArtistsPage = ({ config }) => {
    const [topArtists, setTopArtists] = import_react12.default.useState(100);
    const [dropdown, activeOption, setActiveOption] = useDropdownMenu_default(
      ["short_term", "medium_term", "long_term"],
      ["Past Month", "Past 6 Months", "All Time"],
      `top-artists`
    );
    const fetchTopArtists2 = async (time_range, force, set = true) => {
      if (!force) {
        let storedData = Spicetify.LocalStorage.get(`stats:top-artists:${time_range}`);
        if (storedData) {
          setTopArtists(JSON.parse(storedData));
          return;
        }
      }
      const start = window.performance.now();
      const topArtists2 = await topArtistsReq(time_range, config);
      if (set)
        setTopArtists(topArtists2);
      Spicetify.LocalStorage.set(`stats:top-artists:${time_range}`, JSON.stringify(topArtists2));
      console.log("total artists fetch time:", window.performance.now() - start);
    };
    import_react12.default.useEffect(() => {
      updatePageCache(0, fetchTopArtists2, activeOption);
    }, []);
    import_react12.default.useEffect(() => {
      fetchTopArtists2(activeOption);
    }, [activeOption]);
    const props = {
      title: "Top Artists",
      refreshCallback: () => fetchTopArtists2(activeOption, true),
      config,
      dropdown
    };
    switch (topArtists) {
      case 300:
        return /* @__PURE__ */ import_react12.default.createElement(page_container_default, {
          ...props
        }, /* @__PURE__ */ import_react12.default.createElement(status_default, {
          icon: "error",
          heading: "No API Key or Username",
          subheading: "Please enter these in the settings menu"
        }));
      case 200:
        return /* @__PURE__ */ import_react12.default.createElement(page_container_default, {
          ...props
        }, /* @__PURE__ */ import_react12.default.createElement(status_default, {
          icon: "error",
          heading: "Failed to Fetch Top Artists",
          subheading: "An error occurred while fetching the data"
        }));
      case 100:
        return /* @__PURE__ */ import_react12.default.createElement(page_container_default, {
          ...props
        }, /* @__PURE__ */ import_react12.default.createElement(status_default, {
          icon: "library",
          heading: "Loading",
          subheading: "Fetching data..."
        }));
    }
    const artistCards = topArtists.map((artist, index) => /* @__PURE__ */ import_react12.default.createElement(spotify_card_default, {
      type: artist.uri.includes("last") ? "lastfm" : "artist",
      uri: artist.uri,
      header: artist.name,
      subheader: `#${index + 1} Artist`,
      imageUrl: artist.image
    }));
    return /* @__PURE__ */ import_react12.default.createElement(import_react12.default.Fragment, null, /* @__PURE__ */ import_react12.default.createElement(page_container_default, {
      ...props
    }, /* @__PURE__ */ import_react12.default.createElement("div", {
      className: `main-gridContainer-gridContainer stats-grid`
    }, artistCards)));
  };
  var top_artists_default = import_react12.default.memo(ArtistsPage);

  // src/pages/top_tracks.tsx
  var import_react15 = __toESM(require_react());

  // src/components/track_row.tsx
  var import_react13 = __toESM(require_react());
  var ArtistLink = ({ name, uri, index, length }) => {
    return /* @__PURE__ */ import_react13.default.createElement(import_react13.default.Fragment, null, /* @__PURE__ */ import_react13.default.createElement("a", {
      draggable: "true",
      dir: "auto",
      href: uri,
      tabIndex: -1
    }, name), index === length ? null : ", ");
  };
  var ExplicitBadge = import_react13.default.memo(() => {
    return /* @__PURE__ */ import_react13.default.createElement(import_react13.default.Fragment, null, /* @__PURE__ */ import_react13.default.createElement("span", {
      className: "TypeElement-ballad-textSubdued-type main-trackList-rowBadges",
      "data-encore-id": "type"
    }, /* @__PURE__ */ import_react13.default.createElement("span", {
      "aria-label": "Explicit",
      className: "main-tag-container",
      title: "Explicit"
    }, "E")));
  });
  var LikedIcon = ({ active, uri }) => {
    const [liked, setLiked] = import_react13.default.useState(active);
    const toggleLike = () => {
      if (liked) {
        Spicetify.Platform.LibraryAPI.remove(uri);
      } else {
        Spicetify.Platform.LibraryAPI.add(uri);
      }
      setLiked(!liked);
    };
    import_react13.default.useEffect(() => {
      setLiked(active);
    }, [active]);
    return /* @__PURE__ */ import_react13.default.createElement(Spicetify.ReactComponent.TooltipWrapper, {
      label: liked ? `Remove from Your Library` : "Save to Your Library",
      placement: "top"
    }, /* @__PURE__ */ import_react13.default.createElement("button", {
      type: "button",
      role: "switch",
      "aria-checked": liked,
      "aria-label": "Remove from Your Library",
      onClick: toggleLike,
      className: liked ? "main-addButton-button main-trackList-rowHeartButton main-addButton-active" : "main-addButton-button main-trackList-rowHeartButton",
      tabIndex: -1
    }, /* @__PURE__ */ import_react13.default.createElement("svg", {
      role: "img",
      height: "16",
      width: "16",
      "aria-hidden": "true",
      viewBox: "0 0 16 16",
      "data-encore-id": "icon",
      className: "Svg-img-16 Svg-img-16-icon Svg-img-icon Svg-img-icon-small"
    }, /* @__PURE__ */ import_react13.default.createElement("path", {
      d: liked ? "M15.724 4.22A4.313 4.313 0 0 0 12.192.814a4.269 4.269 0 0 0-3.622 1.13.837.837 0 0 1-1.14 0 4.272 4.272 0 0 0-6.21 5.855l5.916 7.05a1.128 1.128 0 0 0 1.727 0l5.916-7.05a4.228 4.228 0 0 0 .945-3.577z" : "M1.69 2A4.582 4.582 0 0 1 8 2.023 4.583 4.583 0 0 1 11.88.817h.002a4.618 4.618 0 0 1 3.782 3.65v.003a4.543 4.543 0 0 1-1.011 3.84L9.35 14.629a1.765 1.765 0 0 1-2.093.464 1.762 1.762 0 0 1-.605-.463L1.348 8.309A4.582 4.582 0 0 1 1.689 2zm3.158.252A3.082 3.082 0 0 0 2.49 7.337l.005.005L7.8 13.664a.264.264 0 0 0 .311.069.262.262 0 0 0 .09-.069l5.312-6.33a3.043 3.043 0 0 0 .68-2.573 3.118 3.118 0 0 0-2.551-2.463 3.079 3.079 0 0 0-2.612.816l-.007.007a1.501 1.501 0 0 1-2.045 0l-.009-.008a3.082 3.082 0 0 0-2.121-.861z"
    }))));
  };
  var DraggableComponent = ({ uri, title, ...props }) => {
    const dragHandler = Spicetify.ReactHook.DragHandler?.([uri], title);
    return /* @__PURE__ */ import_react13.default.createElement("div", {
      onDragStart: dragHandler,
      draggable: "true",
      ...props
    }, props.children);
  };
  function playAndQueue(uri, uris) {
    uris = uris.filter((u) => !u.includes("last"));
    uris = uris.concat(uris.splice(0, uris.indexOf(uri)));
    queue(uris);
  }
  var MenuWrapper = import_react13.default.memo((props) => /* @__PURE__ */ import_react13.default.createElement(Spicetify.ReactComponent.AlbumMenu, {
    ...props
  }));
  var TrackRow = (props) => {
    const ArtistLinks = props.artists.map((artist, index) => {
      return /* @__PURE__ */ import_react13.default.createElement(ArtistLink, {
        index,
        length: props.artists.length - 1,
        name: artist.name,
        uri: artist.uri
      });
    });
    return /* @__PURE__ */ import_react13.default.createElement(import_react13.default.Fragment, null, /* @__PURE__ */ import_react13.default.createElement(Spicetify.ReactComponent.ContextMenu, {
      menu: /* @__PURE__ */ import_react13.default.createElement(MenuWrapper, {
        uri: props.uri
      }),
      trigger: "right-click"
    }, /* @__PURE__ */ import_react13.default.createElement("div", {
      role: "row",
      "aria-rowindex": 2,
      "aria-selected": "false"
    }, /* @__PURE__ */ import_react13.default.createElement(DraggableComponent, {
      uri: props.uri,
      title: `${props.name} \u2022 ${props.artists.map((artist) => artist.name).join(", ")}`,
      className: "main-trackList-trackListRow main-trackList-trackListRowGrid",
      role: "presentation",
      onClick: (event) => event.detail === 2 && playAndQueue(props.uri, props.uris),
      style: { height: 56 }
    }, /* @__PURE__ */ import_react13.default.createElement("div", {
      className: "main-trackList-rowSectionIndex",
      role: "gridcell",
      "aria-colindex": 1,
      tabIndex: -1
    }, /* @__PURE__ */ import_react13.default.createElement("div", {
      uri: props.uri,
      className: "main-trackList-rowMarker"
    }, /* @__PURE__ */ import_react13.default.createElement("span", {
      className: "TypeElement-ballad-type main-trackList-number",
      "data-encore-id": "type"
    }, props.index), /* @__PURE__ */ import_react13.default.createElement(Spicetify.ReactComponent.TooltipWrapper, {
      label: `Play ${props.name} by ${props.artists.map((artist) => artist.name).join(", ")}`,
      placement: "top"
    }, /* @__PURE__ */ import_react13.default.createElement("button", {
      className: "main-trackList-rowImagePlayButton",
      "aria-label": `Play ${props.name}`,
      tabIndex: -1,
      onClick: () => playAndQueue(props.uri, props.uris)
    }, /* @__PURE__ */ import_react13.default.createElement("svg", {
      role: "img",
      height: "24",
      width: "24",
      "aria-hidden": "true",
      className: "Svg-img-24 Svg-img-24-icon main-trackList-rowPlayPauseIcon",
      viewBox: "0 0 24 24",
      "data-encore-id": "icon"
    }, /* @__PURE__ */ import_react13.default.createElement("path", {
      d: "m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"
    })))))), /* @__PURE__ */ import_react13.default.createElement("div", {
      className: "main-trackList-rowSectionStart",
      role: "gridcell",
      "aria-colindex": 2,
      tabIndex: -1
    }, /* @__PURE__ */ import_react13.default.createElement("img", {
      "aria-hidden": "false",
      draggable: "false",
      loading: "eager",
      src: props.image,
      alt: "",
      className: "main-image-image main-trackList-rowImage main-image-loaded",
      width: "40",
      height: "40"
    }), /* @__PURE__ */ import_react13.default.createElement("div", {
      className: "main-trackList-rowMainContent"
    }, /* @__PURE__ */ import_react13.default.createElement("div", {
      dir: "auto",
      className: "TypeElement-ballad-textBase TypeElement-ballad-textBase-type main-trackList-rowTitle standalone-ellipsis-one-line",
      "data-encore-id": "type"
    }, props.name), props.explicit && /* @__PURE__ */ import_react13.default.createElement(ExplicitBadge, null), /* @__PURE__ */ import_react13.default.createElement("span", {
      className: "TypeElement-mesto-textSubdued TypeElement-mesto-textSubdued-type main-trackList-rowSubTitle standalone-ellipsis-one-line",
      "data-encore-id": "type"
    }, ArtistLinks))), /* @__PURE__ */ import_react13.default.createElement("div", {
      className: "main-trackList-rowSectionVariable",
      role: "gridcell",
      "aria-colindex": 3,
      tabIndex: -1
    }, /* @__PURE__ */ import_react13.default.createElement("span", {
      "data-encore-id": "type",
      className: "TypeElement-mesto TypeElement-mesto-type"
    }, /* @__PURE__ */ import_react13.default.createElement("a", {
      draggable: "true",
      className: "standalone-ellipsis-one-line",
      dir: "auto",
      href: props.album_uri,
      tabIndex: -1
    }, props.album))), /* @__PURE__ */ import_react13.default.createElement("div", {
      className: "main-trackList-rowSectionEnd",
      role: "gridcell",
      "aria-colindex": 5,
      tabIndex: -1
    }, /* @__PURE__ */ import_react13.default.createElement(LikedIcon, {
      active: props.liked || false,
      uri: props.uri
    }), /* @__PURE__ */ import_react13.default.createElement("div", {
      className: "TypeElement-mesto-textSubdued TypeElement-mesto-textSubdued-type main-trackList-rowDuration",
      "data-encore-id": "type"
    }, Spicetify.Player.formatTime(props.duration)), /* @__PURE__ */ import_react13.default.createElement(Spicetify.ReactComponent.ContextMenu, {
      menu: /* @__PURE__ */ import_react13.default.createElement(MenuWrapper, {
        uri: props.uri
      }),
      trigger: "click"
    }, /* @__PURE__ */ import_react13.default.createElement("button", {
      type: "button",
      "aria-haspopup": "menu",
      "aria-label": `More options for ${props.name}`,
      className: "main-moreButton-button Button-sm-16-buttonTertiary-iconOnly-condensed-useBrowserDefaultFocusStyle Button-small-small-buttonTertiary-iconOnly-condensed-useBrowserDefaultFocusStyle main-trackList-rowMoreButton",
      tabIndex: -1
    }, /* @__PURE__ */ import_react13.default.createElement(Spicetify.ReactComponent.TooltipWrapper, {
      label: `More options for ${props.name} by ${props.artists.map((artist) => artist.name).join(", ")}`,
      placement: "top"
    }, /* @__PURE__ */ import_react13.default.createElement("span", null, /* @__PURE__ */ import_react13.default.createElement("svg", {
      role: "img",
      height: "16",
      width: "16",
      "aria-hidden": "true",
      viewBox: "0 0 16 16",
      "data-encore-id": "icon",
      className: "Svg-img-16 Svg-img-16-icon Svg-img-icon Svg-img-icon-small"
    }, /* @__PURE__ */ import_react13.default.createElement("path", {
      d: "M3 8a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm6.5 0a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zM16 8a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"
    })))))))))));
  };
  var track_row_default = import_react13.default.memo(TrackRow);

  // src/components/tracklist.tsx
  var import_react14 = __toESM(require_react());
  var Tracklist = ({ minified = false, children }) => {
    return /* @__PURE__ */ import_react14.default.createElement("div", {
      role: "grid",
      "aria-rowcount": minified ? 5 : 50,
      "aria-colcount": 4,
      className: "main-trackList-trackList main-trackList-indexable",
      tabIndex: 0
    }, !minified && /* @__PURE__ */ import_react14.default.createElement("div", {
      className: "main-trackList-trackListHeader",
      role: "presentation"
    }, /* @__PURE__ */ import_react14.default.createElement("div", {
      className: "main-trackList-trackListHeaderRow main-trackList-trackListRowGrid",
      role: "row",
      "aria-rowindex": 1
    }, /* @__PURE__ */ import_react14.default.createElement("div", {
      className: "main-trackList-rowSectionIndex",
      role: "columnheader",
      "aria-colindex": 1,
      "aria-sort": "none",
      tabIndex: -1
    }, "#"), /* @__PURE__ */ import_react14.default.createElement("div", {
      className: "main-trackList-rowSectionStart",
      role: "columnheader",
      "aria-colindex": 2,
      "aria-sort": "none",
      tabIndex: -1
    }, /* @__PURE__ */ import_react14.default.createElement("button", {
      className: "main-trackList-column main-trackList-sortable",
      tabIndex: -1
    }, /* @__PURE__ */ import_react14.default.createElement("span", {
      className: "TypeElement-mesto-type standalone-ellipsis-one-line",
      "data-encore-id": "type"
    }, "Title"))), /* @__PURE__ */ import_react14.default.createElement("div", {
      className: "main-trackList-rowSectionVariable",
      role: "columnheader",
      "aria-colindex": 3,
      "aria-sort": "none",
      tabIndex: -1
    }, /* @__PURE__ */ import_react14.default.createElement("button", {
      className: "main-trackList-column main-trackList-sortable",
      tabIndex: -1
    }, /* @__PURE__ */ import_react14.default.createElement("span", {
      className: "TypeElement-mesto-type standalone-ellipsis-one-line",
      "data-encore-id": "type"
    }, "Album"))), /* @__PURE__ */ import_react14.default.createElement("div", {
      className: "main-trackList-rowSectionEnd",
      role: "columnheader",
      "aria-colindex": 5,
      "aria-sort": "none",
      tabIndex: -1
    }, /* @__PURE__ */ import_react14.default.createElement(Spicetify.ReactComponent.TooltipWrapper, {
      label: "Duration",
      placement: "top"
    }, /* @__PURE__ */ import_react14.default.createElement("button", {
      "aria-label": "Duration",
      className: "main-trackList-column main-trackList-durationHeader main-trackList-sortable",
      tabIndex: -1
    }, /* @__PURE__ */ import_react14.default.createElement("svg", {
      role: "img",
      height: "16",
      width: "16",
      "aria-hidden": "true",
      viewBox: "0 0 16 16",
      "data-encore-id": "icon",
      className: "Svg-img-16 Svg-img-16-icon Svg-img-icon Svg-img-icon-small"
    }, /* @__PURE__ */ import_react14.default.createElement("path", {
      d: "M8 1.5a6.5 6.5 0 1 0 0 13 6.5 6.5 0 0 0 0-13zM0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8z"
    }), /* @__PURE__ */ import_react14.default.createElement("path", {
      d: "M8 3.25a.75.75 0 0 1 .75.75v3.25H11a.75.75 0 0 1 0 1.5H7.25V4A.75.75 0 0 1 8 3.25z"
    }))))))), /* @__PURE__ */ import_react14.default.createElement("div", {
      className: "main-rootlist-wrapper",
      role: "presentation",
      style: { height: (minified ? 5 : 50) * 56 }
    }, /* @__PURE__ */ import_react14.default.createElement("div", {
      role: "presentation"
    }, children)));
  };
  var tracklist_default = Tracklist;

  // src/pages/top_tracks.tsx
  var topTracksReq = async (time_range, config) => {
    if (config.CONFIG["use-lastfm"] === true) {
      if (!config.CONFIG["api-key"] || !config.CONFIG["lastfm-user"]) {
        return 300;
      }
      const lastfmperiods = {
        short_term: "1month",
        medium_term: "6month",
        long_term: "overall"
      };
      const lastfmData = await apiRequest(
        "lastfm",
        `https://ws.audioscrobbler.com/2.0/?method=user.gettoptracks&user=${config.CONFIG["lastfm-user"]}&api_key=${config.CONFIG["api-key"]}&format=json&period=${lastfmperiods[time_range]}`
      );
      if (!lastfmData) {
        return 200;
      }
      const spotifyData = await convertToSpotify(lastfmData.toptracks.track, "tracks");
      const fetchedLikedArray = await checkLiked(spotifyData.map((track) => track.id));
      if (!fetchedLikedArray) {
        return 200;
      }
      spotifyData.forEach((track, index) => {
        track.liked = fetchedLikedArray[index];
      });
      return spotifyData;
    } else {
      const response = await apiRequest("topTracks", `https://api.spotify.com/v1/me/top/tracks?limit=50&offset=0&time_range=${time_range}`);
      if (!response) {
        return 200;
      }
      const fetchedLikedArray = await checkLiked(response.items.map((track) => track.id));
      if (!fetchedLikedArray) {
        return 200;
      }
      return response.items.map((track, index) => {
        return {
          liked: fetchedLikedArray[index],
          name: track.name,
          image: track.album.images[2] ? track.album.images[2].url : track.album.images[1] ? track.album.images[1].url : "https://images.squarespace-cdn.com/content/v1/55fc0004e4b069a519961e2d/1442590746571-RPGKIXWGOO671REUNMCB/image-asset.gif",
          uri: track.uri,
          id: track.id,
          artists: track.artists.map((artist) => ({ name: artist.name, uri: artist.uri })),
          duration: track.duration_ms,
          album: track.album.name,
          album_uri: track.album.uri,
          popularity: track.popularity,
          explicit: track.explicit,
          release_year: track.album.release_date.slice(0, 4)
        };
      });
    }
  };
  var TracksPage = ({ config }) => {
    const { LocalStorage } = Spicetify;
    const [topTracks, setTopTracks] = import_react15.default.useState(100);
    const [dropdown, activeOption, setActiveOption] = useDropdownMenu_default(
      ["short_term", "medium_term", "long_term"],
      ["Past Month", "Past 6 Months", "All Time"],
      "top-tracks"
    );
    const fetchTopTracks = async (time_range, force, set = true) => {
      if (!force) {
        let storedData = LocalStorage.get(`stats:top-tracks:${time_range}`);
        if (storedData) {
          setTopTracks(JSON.parse(storedData));
          return;
        }
      }
      const start = window.performance.now();
      if (!time_range)
        return;
      const topTracks2 = await topTracksReq(time_range, config);
      if (set)
        setTopTracks(topTracks2);
      LocalStorage.set(`stats:top-tracks:${time_range}`, JSON.stringify(topTracks2));
      console.log("total tracks fetch time:", window.performance.now() - start);
    };
    import_react15.default.useEffect(() => {
      updatePageCache(1, fetchTopTracks, activeOption);
    }, []);
    import_react15.default.useEffect(() => {
      fetchTopTracks(activeOption);
    }, [activeOption]);
    const props = {
      title: "Top Tracks",
      refreshCallback: () => fetchTopTracks(activeOption, true),
      config,
      dropdown
    };
    switch (topTracks) {
      case 300:
        return /* @__PURE__ */ import_react15.default.createElement(page_container_default, {
          ...props
        }, /* @__PURE__ */ import_react15.default.createElement(status_default, {
          icon: "error",
          heading: "No API Key or Username",
          subheading: "Please enter these in the settings menu"
        }));
      case 200:
        return /* @__PURE__ */ import_react15.default.createElement(page_container_default, {
          ...props
        }, /* @__PURE__ */ import_react15.default.createElement(status_default, {
          icon: "error",
          heading: "Failed to Fetch Top Tracks",
          subheading: "An error occurred while fetching the data"
        }));
      case 100:
        return /* @__PURE__ */ import_react15.default.createElement(page_container_default, {
          ...props
        }, /* @__PURE__ */ import_react15.default.createElement(status_default, {
          icon: "library",
          heading: "Loading",
          subheading: "Fetching data..."
        }));
    }
    const infoToCreatePlaylist = {
      playlistName: `Top Songs - ${activeOption}`,
      itemsUris: topTracks.map((track) => track.uri)
    };
    const trackRows = topTracks.map((track, index) => /* @__PURE__ */ import_react15.default.createElement(track_row_default, {
      index: index + 1,
      ...track,
      uris: topTracks.map((track2) => track2.uri)
    }));
    return /* @__PURE__ */ import_react15.default.createElement(page_container_default, {
      ...props,
      infoToCreatePlaylist
    }, /* @__PURE__ */ import_react15.default.createElement(tracklist_default, null, trackRows));
  };
  var top_tracks_default = import_react15.default.memo(TracksPage);

  // src/pages/top_genres.tsx
  var import_react20 = __toESM(require_react());

  // src/components/cards/stat_card.tsx
  var import_react16 = __toESM(require_react());
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
    return /* @__PURE__ */ import_react16.default.createElement("div", {
      className: "main-card-card"
    }, /* @__PURE__ */ import_react16.default.createElement(TextComponent, {
      as: "div",
      semanticColor: "textBase",
      variant: "alto",
      children: typeof value === "number" ? formatValue(label, value) : value
    }), /* @__PURE__ */ import_react16.default.createElement(TextComponent, {
      as: "div",
      semanticColor: "textBase",
      variant: "balladBold",
      children: normalizeString(label)
    }));
  }
  var stat_card_default = StatCard;

  // src/components/cards/genres_card.tsx
  var import_react17 = __toESM(require_react());
  var genreLine = (name, value, limit, total) => {
    return /* @__PURE__ */ import_react17.default.createElement("div", {
      className: "stats-genreRow"
    }, /* @__PURE__ */ import_react17.default.createElement("div", {
      className: "stats-genreRowFill",
      style: {
        width: `calc(${value / limit * 100}% + ${(limit - value) / (limit - 1) * 100}px)`
      }
    }, /* @__PURE__ */ import_react17.default.createElement("span", {
      className: "stats-genreText"
    }, name)), /* @__PURE__ */ import_react17.default.createElement("span", {
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
    return /* @__PURE__ */ import_react17.default.createElement("div", {
      className: `main-card-card stats-genreCard`
    }, genreLines(genresArray, total));
  };
  var genres_card_default = genresCard;

  // src/components/inline_grid.tsx
  var import_react18 = __toESM(require_react());
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
    return /* @__PURE__ */ import_react18.default.createElement("section", {
      className: "stats-gridInlineSection"
    }, /* @__PURE__ */ import_react18.default.createElement("button", {
      className: "stats-scrollButton",
      onClick: scrollGridLeft
    }, "<"), /* @__PURE__ */ import_react18.default.createElement("button", {
      className: "stats-scrollButton",
      onClick: scrollGrid
    }, ">"), /* @__PURE__ */ import_react18.default.createElement("div", {
      className: `main-gridContainer-gridContainer stats-gridInline${special ? " stats-specialGrid" : ""}`,
      "data-scroll": "start"
    }, children));
  }
  var inline_grid_default = import_react18.default.memo(InlineGrid);

  // src/components/shelf.tsx
  var import_react19 = __toESM(require_react());
  function Shelf(props) {
    const { TextComponent } = Spicetify.ReactComponent;
    const { title, children } = props;
    return /* @__PURE__ */ import_react19.default.createElement("section", {
      className: "main-shelf-shelf Shelf"
    }, /* @__PURE__ */ import_react19.default.createElement("div", {
      className: "main-shelf-header"
    }, /* @__PURE__ */ import_react19.default.createElement("div", {
      className: "main-shelf-topRow"
    }, /* @__PURE__ */ import_react19.default.createElement("div", {
      className: "main-shelf-titleWrapper"
    }, /* @__PURE__ */ import_react19.default.createElement(TextComponent, {
      children: title,
      as: "h2",
      variant: "canon",
      semanticColor: "textBase"
    })))), /* @__PURE__ */ import_react19.default.createElement("section", null, children));
  }
  var shelf_default = import_react19.default.memo(Shelf);

  // src/pages/top_genres.tsx
  var GenresPage = ({ config }) => {
    const { LocalStorage, CosmosAsync } = Spicetify;
    const [topGenres, setTopGenres] = import_react20.default.useState(100);
    const [dropdown, activeOption] = useDropdownMenu_default(
      ["short_term", "medium_term", "long_term"],
      ["Past Month", "Past 6 Months", "All Time"],
      "top-genres"
    );
    const fetchTopGenres = async (time_range, force, set = true, force_refetch) => {
      if (!force) {
        let storedData = LocalStorage.get(`stats:top-genres:${time_range}`);
        if (storedData) {
          setTopGenres(JSON.parse(storedData));
          return;
        }
      }
      const start = window.performance.now();
      const cacheInfo = JSON.parse(LocalStorage.get("stats:cache-info"));
      const fetchedItems = await Promise.all(
        ["artists", "tracks"].map(async (type, index) => {
          if (cacheInfo[index] === true && !force_refetch) {
            return await JSON.parse(LocalStorage.get(`stats:top-${type}:${time_range}`));
          }
          const fetchedItems2 = await (type === "artists" ? topArtistsReq(time_range, config) : topTracksReq(time_range, config));
          cacheInfo[index] = true;
          cacheInfo[2] = true;
          LocalStorage.set(`stats:top-${type}:${time_range}`, JSON.stringify(fetchedItems2));
          LocalStorage.set("stats:cache-info", JSON.stringify(cacheInfo));
          return fetchedItems2;
        })
      );
      for (let i = 0; i < 2; i++) {
        if (fetchedItems[i] === 200 || fetchedItems[i] === 300)
          return setTopGenres(fetchedItems[i]);
      }
      const fetchedArtists = fetchedItems[0].filter((artist) => artist?.genres);
      const fetchedTracks = fetchedItems[1].filter((track) => track?.id);
      const genres = fetchedArtists.reduce((acc, artist) => {
        artist.genres.forEach((genre) => {
          const index = acc.findIndex(([g]) => g === genre);
          if (index !== -1) {
            acc[index][1] += 1 * Math.abs(fetchedArtists.indexOf(artist) - 50);
          } else {
            acc.push([genre, 1 * Math.abs(fetchedArtists.indexOf(artist) - 50)]);
          }
        });
        return acc;
      }, []);
      let trackPopularity = 0;
      let explicitness = 0;
      let releaseData = [];
      const topTracks = fetchedTracks.map((track) => {
        trackPopularity += track.popularity;
        if (track.explicit)
          explicitness++;
        if (track.release_year) {
          const year = track.release_year;
          const index = releaseData.findIndex(([y]) => y === year);
          if (index !== -1) {
            releaseData[index][1] += 1;
          } else {
            releaseData.push([year, 1]);
          }
        }
        return track.id;
      });
      async function testDupe(track) {
        const spotifyItem = await CosmosAsync.get(
          `https://api.spotify.com/v1/search?q=track:${filterLink(track.name)}+artist:${filterLink(track.artists[0].name)}&type=track`
        ).then((res) => res.tracks?.items);
        if (!spotifyItem)
          return false;
        return spotifyItem.some((item) => {
          return item.name === track.name && item.popularity > track.popularity;
        });
      }
      let obscureTracks2 = [];
      for (let i = 0; i < fetchedTracks.length; i++) {
        let track = fetchedTracks[i];
        if (!track?.popularity)
          continue;
        if (obscureTracks2.length < 5) {
          const dupe = await testDupe(track);
          if (dupe)
            continue;
          obscureTracks2.push(track);
          obscureTracks2.sort((a, b) => b.popularity - a.popularity);
          continue;
        }
        for (let j = 0; j < 5; j++) {
          if (track.popularity < obscureTracks2[j].popularity) {
            const dupe = await testDupe(track);
            if (dupe)
              break;
            obscureTracks2.splice(j, 0, track);
            obscureTracks2 = obscureTracks2.slice(0, 5);
            break;
          }
        }
      }
      const fetchedFeatures = await fetchAudioFeatures(topTracks);
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
      audioFeatures = { popularity: trackPopularity, explicitness, ...audioFeatures };
      for (let key in audioFeatures) {
        audioFeatures[key] = audioFeatures[key] / 50;
      }
      console.log("total genres fetch time:", window.performance.now() - start);
      if (set)
        setTopGenres({ genres, features: audioFeatures, years: releaseData, obscureTracks: obscureTracks2 });
      LocalStorage.set(
        `stats:top-genres:${time_range}`,
        JSON.stringify({ genres, features: audioFeatures, years: releaseData, obscureTracks: obscureTracks2 })
      );
    };
    import_react20.default.useEffect(() => {
      updatePageCache(2, fetchTopGenres, activeOption);
    }, []);
    import_react20.default.useEffect(() => {
      fetchTopGenres(activeOption);
    }, [activeOption]);
    const props = {
      title: "Top Genres",
      refreshCallback: () => fetchTopGenres(activeOption, true, true, true),
      config,
      dropdown
    };
    switch (topGenres) {
      case 300:
        return /* @__PURE__ */ import_react20.default.createElement(page_container_default, {
          ...props
        }, /* @__PURE__ */ import_react20.default.createElement(status_default, {
          icon: "error",
          heading: "No API Key or Username",
          subheading: "Please enter these in the settings menu"
        }));
      case 200:
        return /* @__PURE__ */ import_react20.default.createElement(page_container_default, {
          ...props
        }, /* @__PURE__ */ import_react20.default.createElement(status_default, {
          icon: "error",
          heading: "Failed to Fetch Top Genres",
          subheading: "An error occurred while fetching the data"
        }));
      case 100:
        return /* @__PURE__ */ import_react20.default.createElement(page_container_default, {
          ...props
        }, /* @__PURE__ */ import_react20.default.createElement(status_default, {
          icon: "library",
          heading: "Loading",
          subheading: "Fetching data..."
        }));
    }
    const statCards = Object.entries(topGenres.features).map(([key, value]) => {
      return /* @__PURE__ */ import_react20.default.createElement(stat_card_default, {
        label: key,
        value
      });
    });
    const obscureTracks = topGenres.obscureTracks.map((track, index) => /* @__PURE__ */ import_react20.default.createElement(track_row_default, {
      index: index + 1,
      ...track,
      uris: topGenres.obscureTracks.map((track2) => track2.uri)
    }));
    return /* @__PURE__ */ import_react20.default.createElement(page_container_default, {
      ...props
    }, /* @__PURE__ */ import_react20.default.createElement("section", {
      className: "main-shelf-shelf Shelf"
    }, /* @__PURE__ */ import_react20.default.createElement(genres_card_default, {
      genres: topGenres.genres,
      total: 1275
    }), /* @__PURE__ */ import_react20.default.createElement(inline_grid_default, {
      special: true
    }, statCards)), /* @__PURE__ */ import_react20.default.createElement(shelf_default, {
      title: "Release Year Distribution"
    }, /* @__PURE__ */ import_react20.default.createElement(genres_card_default, {
      genres: topGenres.years,
      total: 50
    })), /* @__PURE__ */ import_react20.default.createElement(shelf_default, {
      title: "Most Obscure Tracks"
    }, /* @__PURE__ */ import_react20.default.createElement(tracklist_default, {
      minified: true
    }, obscureTracks)));
  };
  var top_genres_default = import_react20.default.memo(GenresPage);

  // src/pages/library.tsx
  var import_react21 = __toESM(require_react());
  var LibraryPage = ({ config }) => {
    const [library, setLibrary] = import_react21.default.useState(100);
    const [dropdown, activeOption, setActiveOption] = useDropdownMenu_default(["owned", "all"], ["My Playlists", "All Playlists"], "library");
    const fetchData = async (option, force, set = true) => {
      try {
        if (!force) {
          let storedData = Spicetify.LocalStorage.get(`stats:library:${option}`);
          if (storedData) {
            setLibrary(JSON.parse(storedData));
            return;
          }
        }
        const start = window.performance.now();
        const rootlistItems = await apiRequest("rootlist", "sp://core-playlist/v1/rootlist");
        const flattenPlaylists = (items) => {
          const playlists2 = [];
          items.forEach((row) => {
            if (row.type === "playlist") {
              playlists2.push(row);
            } else if (row.type === "folder") {
              if (!row.rows)
                return;
              const folderPlaylists = flattenPlaylists(row.rows);
              playlists2.push(...folderPlaylists);
            }
          });
          return playlists2;
        };
        let playlists = flattenPlaylists(rootlistItems?.rows);
        playlists = playlists.sort((a, b) => a.ownedBySelf === b.ownedBySelf ? 0 : a.ownedBySelf ? -1 : 1);
        let indexOfFirstNotOwned = -1;
        let playlistUris = [];
        let trackCount = 0;
        let ownedTrackCount = 0;
        playlists.forEach((playlist) => {
          if (playlist.totalLength === 0)
            return;
          if (!playlist.ownedBySelf && indexOfFirstNotOwned === -1)
            indexOfFirstNotOwned = playlistUris.length;
          playlistUris.push(playlist.link);
          trackCount += playlist.totalLength;
          if (playlist.ownedBySelf)
            ownedTrackCount += playlist.totalLength;
        }, 0);
        const playlistsMeta = await Promise.all(
          playlistUris.map((uri) => {
            return apiRequest("playlistsMetadata", `sp://core-playlist/v1/playlist/${uri}`, 5, false);
          })
        );
        let duration = 0;
        let trackIDs = [];
        let popularity = 0;
        let albums = {};
        let artists = {};
        let explicitCount = 0;
        let ownedDuration = 0;
        let ownedArtists = {};
        let ownedPopularity = 0;
        let ownedAlbums = {};
        let ownedExplicitCount = 0;
        for (let i = 0; i < playlistsMeta.length; i++) {
          const playlist = playlistsMeta[i];
          if (!playlist)
            continue;
          if (i === indexOfFirstNotOwned) {
            ownedDuration = duration;
            ownedArtists = Object.assign({}, artists);
            ownedPopularity = popularity;
            ownedExplicitCount = explicitCount;
            ownedAlbums = Object.assign({}, albums);
          }
          duration += playlist.playlist.duration;
          playlist.items.forEach((track) => {
            if (!track?.album)
              return;
            if (track.link.includes("local"))
              return;
            trackIDs.push(track.link.split(":")[2]);
            if (track.isExplicit)
              explicitCount++;
            popularity += track.popularity;
            const albumID = track.album.link.split(":")[2];
            albums[albumID] = albums[albumID] ? albums[albumID] + 1 : 1;
            track.artists.forEach((artist) => {
              const artistID = artist.link.split(":")[2];
              artists[artistID] = artists[artistID] ? artists[artistID] + 1 : 1;
            });
          });
        }
        const [topArtists, topGenres, topGenresTotal] = await fetchTopArtists(artists);
        const [ownedTopArtists, ownedTopGenres, ownedTopGenresTotal] = await fetchTopArtists(ownedArtists);
        const [topAlbums, releaseYears, releaseYearsTotal] = await fetchTopAlbums(albums);
        const [ownedTopAlbums, ownedReleaseYears, ownedReleaseYearsTotal] = await fetchTopAlbums(ownedAlbums, topAlbums);
        const fetchedFeatures = await fetchAudioFeatures(trackIDs);
        const audioFeatures = {
          danceability: 0,
          energy: 0,
          valence: 0,
          speechiness: 0,
          acousticness: 0,
          instrumentalness: 0,
          liveness: 0,
          tempo: 0
        };
        let ownedAudioFeatures = {};
        for (let i = 0; i < fetchedFeatures.length; i++) {
          if (i === ownedTrackCount) {
            ownedAudioFeatures = { popularity: ownedPopularity, explicitness: ownedExplicitCount, ...audioFeatures };
          }
          if (!fetchedFeatures[i])
            continue;
          const track = fetchedFeatures[i];
          Object.keys(audioFeatures).forEach((feature) => {
            audioFeatures[feature] += track[feature];
          });
        }
        const allAudioFeatures = { popularity, explicitness: explicitCount, ...audioFeatures };
        for (let key in allAudioFeatures) {
          allAudioFeatures[key] /= fetchedFeatures.length;
        }
        for (let key in ownedAudioFeatures) {
          ownedAudioFeatures[key] /= ownedTrackCount;
        }
        const ownedStats = {
          audioFeatures: ownedAudioFeatures,
          trackCount: ownedTrackCount,
          totalDuration: ownedDuration,
          artists: ownedTopArtists,
          artistCount: Object.keys(ownedArtists).length,
          genres: ownedTopGenres,
          genresDenominator: ownedTopGenresTotal,
          playlistCount: indexOfFirstNotOwned > 0 ? indexOfFirstNotOwned : 0,
          albums: ownedTopAlbums,
          years: ownedReleaseYears,
          yearsDenominator: ownedReleaseYearsTotal
        };
        const allStats = {
          playlistCount: playlists.length,
          audioFeatures: allAudioFeatures,
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
        if (set) {
          if (option === "all" && allStats.playlistCount)
            setLibrary(allStats);
          else if (option === "owned" && ownedStats.playlistCount)
            setLibrary(ownedStats);
          else
            return setLibrary(300);
        }
        Spicetify.LocalStorage.set(`stats:library:all`, JSON.stringify(allStats));
        Spicetify.LocalStorage.set(`stats:library:owned`, JSON.stringify(ownedStats));
        console.log("total library fetch time:", window.performance.now() - start);
      } catch (e) {
        console.error(e);
        setLibrary(200);
      }
    };
    import_react21.default.useEffect(() => {
      updatePageCache(3, fetchData, activeOption, true);
    }, []);
    import_react21.default.useEffect(() => {
      fetchData(activeOption);
    }, [activeOption]);
    const props = {
      refreshCallback: () => fetchData(activeOption, true),
      config,
      dropdown
    };
    switch (library) {
      case 300:
        return /* @__PURE__ */ import_react21.default.createElement(page_container_default, {
          title: `Library Analysis`,
          ...props
        }, /* @__PURE__ */ import_react21.default.createElement(status_default, {
          icon: "error",
          heading: "No Playlists In Your Library",
          subheading: "Try adding some playlists first"
        }));
      case 200:
        return /* @__PURE__ */ import_react21.default.createElement(page_container_default, {
          title: `Library Analysis`,
          ...props
        }, /* @__PURE__ */ import_react21.default.createElement(status_default, {
          icon: "error",
          heading: "Failed to Fetch Stats",
          subheading: "Make an issue on Github"
        }));
      case 100:
        return /* @__PURE__ */ import_react21.default.createElement(page_container_default, {
          title: `Library Analysis`,
          ...props
        }, /* @__PURE__ */ import_react21.default.createElement(status_default, {
          icon: "library",
          heading: "Analysing your Library",
          subheading: "This may take a while"
        }));
    }
    const statCards = Object.entries(library.audioFeatures).map(([key, value]) => {
      return /* @__PURE__ */ import_react21.default.createElement(stat_card_default, {
        label: key,
        value
      });
    });
    const artistCards = library.artists.slice(0, 10).map((artist) => {
      return /* @__PURE__ */ import_react21.default.createElement(spotify_card_default, {
        type: "artist",
        uri: artist.uri,
        header: artist.name,
        subheader: `Appears in ${artist.freq} tracks`,
        imageUrl: artist.image
      });
    });
    const albumCards = library.albums.map((album) => {
      return /* @__PURE__ */ import_react21.default.createElement(spotify_card_default, {
        type: "album",
        uri: album.uri,
        header: album.name,
        subheader: `Appears in ${album.freq} tracks`,
        imageUrl: album.image
      });
    });
    return /* @__PURE__ */ import_react21.default.createElement(page_container_default, {
      title: "Library Analysis",
      ...props
    }, /* @__PURE__ */ import_react21.default.createElement("section", {
      className: "stats-libraryOverview"
    }, /* @__PURE__ */ import_react21.default.createElement(stat_card_default, {
      label: "Total Playlists",
      value: library.playlistCount.toString()
    }), /* @__PURE__ */ import_react21.default.createElement(stat_card_default, {
      label: "Total Tracks",
      value: library.trackCount.toString()
    }), /* @__PURE__ */ import_react21.default.createElement(stat_card_default, {
      label: "Total Artists",
      value: library.artistCount.toString()
    }), /* @__PURE__ */ import_react21.default.createElement(stat_card_default, {
      label: "Total Minutes",
      value: Math.floor(library.totalDuration / 60).toString()
    }), /* @__PURE__ */ import_react21.default.createElement(stat_card_default, {
      label: "Total Hours",
      value: (library.totalDuration / (60 * 60)).toFixed(1)
    })), /* @__PURE__ */ import_react21.default.createElement(shelf_default, {
      title: "Most Frequent Genres"
    }, /* @__PURE__ */ import_react21.default.createElement(genres_card_default, {
      genres: library.genres,
      total: library.genresDenominator
    }), /* @__PURE__ */ import_react21.default.createElement(inline_grid_default, {
      special: true
    }, statCards)), /* @__PURE__ */ import_react21.default.createElement(shelf_default, {
      title: "Most Frequent Artists"
    }, /* @__PURE__ */ import_react21.default.createElement(inline_grid_default, null, artistCards)), /* @__PURE__ */ import_react21.default.createElement(shelf_default, {
      title: "Most Frequent Albums"
    }, /* @__PURE__ */ import_react21.default.createElement(inline_grid_default, null, albumCards)), /* @__PURE__ */ import_react21.default.createElement(shelf_default, {
      title: "Release Year Distribution"
    }, /* @__PURE__ */ import_react21.default.createElement(genres_card_default, {
      genres: library.years,
      total: library.yearsDenominator
    })));
  };
  var library_default = import_react21.default.memo(LibraryPage);

  // src/pages/charts.tsx
  var import_react22 = __toESM(require_react());
  var ChartsPage = ({ config }) => {
    const [chartData, setChartData] = import_react22.default.useState(100);
    const [dropdown, activeOption, setActiveOption] = useDropdownMenu_default(["artists", "tracks"], ["Top Artists", "Top Tracks"], "charts");
    async function fetchChartData(type, force, set = true) {
      if (!force) {
        let storedData = Spicetify.LocalStorage.get(`stats:charts:${type}`);
        if (storedData) {
          setChartData(JSON.parse(storedData));
          return;
        }
      }
      const api_key = config.CONFIG["api-key"];
      if (!api_key) {
        setChartData(200);
        return;
      }
      const response = await apiRequest("charts", `http://ws.audioscrobbler.com/2.0/?method=chart.gettop${type}&api_key=${api_key}&format=json`);
      if (!response) {
        setChartData(500);
        return;
      }
      const data = response[type].track || response[type].artist;
      const cardData = await convertToSpotify(data, type);
      if (type === "tracks") {
        const fetchedLikedArray = await checkLiked(cardData.map((track) => track.id));
        if (!fetchedLikedArray) {
          setChartData(200);
          return;
        }
        cardData.forEach((track, index) => {
          track.liked = fetchedLikedArray[index];
        });
      }
      if (set)
        setChartData(cardData);
      Spicetify.LocalStorage.set(`stats:charts:${type}`, JSON.stringify(cardData));
    }
    import_react22.default.useEffect(() => {
      updatePageCache(4, fetchChartData, activeOption, "charts");
    }, []);
    import_react22.default.useEffect(() => {
      fetchChartData(activeOption);
    }, [activeOption]);
    const props = {
      title: `Charts -  Top ${activeOption.charAt(0).toUpperCase()}${activeOption.slice(1)}`,
      refreshCallback: () => fetchChartData(activeOption, true),
      config,
      dropdown
    };
    switch (chartData) {
      case 200:
        return /* @__PURE__ */ import_react22.default.createElement(page_container_default, {
          ...props
        }, /* @__PURE__ */ import_react22.default.createElement(status_default, {
          icon: "error",
          heading: "No API Key",
          subheading: "Please enter your Last.fm API key in the settings menu."
        }));
      case 500:
        return /* @__PURE__ */ import_react22.default.createElement(page_container_default, {
          ...props
        }, /* @__PURE__ */ import_react22.default.createElement(status_default, {
          icon: "error",
          heading: "Error",
          subheading: "An error occurred while fetching the data."
        }));
      case 100:
        return /* @__PURE__ */ import_react22.default.createElement(page_container_default, {
          ...props
        }, /* @__PURE__ */ import_react22.default.createElement(status_default, {
          icon: "library",
          heading: "Loading",
          subheading: "Fetching data from Last.fm..."
        }));
    }
    if (!chartData[0]?.album) {
      const artistCards = chartData.map((artist, index) => {
        const type = artist.uri.startsWith("https") ? "lastfm" : "artist";
        return /* @__PURE__ */ import_react22.default.createElement(spotify_card_default, {
          type,
          uri: artist.uri,
          header: artist.name,
          subheader: `#${index + 1} Artist`,
          imageUrl: artist.image
        });
      });
      props.title = `Charts - Top Artists`;
      return /* @__PURE__ */ import_react22.default.createElement(page_container_default, {
        ...props
      }, /* @__PURE__ */ import_react22.default.createElement("div", {
        className: `main-gridContainer-gridContainer stats-grid`
      }, artistCards));
    } else {
      const date = new Date().toLocaleDateString("en-US", {
        year: "numeric",
        month: "2-digit",
        day: "2-digit"
      });
      const infoToCreatePlaylist = {
        playlistName: `Charts - Top Tracks - ${date}`,
        itemsUris: chartData.map((track) => track.uri)
      };
      const trackRows = chartData.map((track, index) => /* @__PURE__ */ import_react22.default.createElement(track_row_default, {
        index: index + 1,
        ...track,
        uris: chartData.map((track2) => track2.uri)
      }));
      props.title = `Charts - Top Tracks`;
      return /* @__PURE__ */ import_react22.default.createElement(page_container_default, {
        ...props,
        infoToCreatePlaylist
      }, /* @__PURE__ */ import_react22.default.createElement(tracklist_default, null, trackRows));
    }
  };
  var charts_default = import_react22.default.memo(ChartsPage);

  // src/pages/top_albums.tsx
  var import_react23 = __toESM(require_react());
  var topAlbumsReq = async (time_range, config) => {
    if (!config.CONFIG["api-key"] || !config.CONFIG["lastfm-user"]) {
      return 300;
    }
    const lastfmperiods = {
      short_term: "1month",
      medium_term: "6month",
      long_term: "overall"
    };
    const response = await apiRequest(
      "lastfm",
      `https://ws.audioscrobbler.com/2.0/?method=user.gettopalbums&user=${config.CONFIG["lastfm-user"]}&api_key=${config.CONFIG["api-key"]}&format=json&period=${lastfmperiods[time_range]}`
    );
    if (!response) {
      return 200;
    }
    return await convertToSpotify(response.topalbums.album, "albums");
  };
  var AlbumsPage = ({ config }) => {
    const { LocalStorage } = Spicetify;
    const [topAlbums, setTopAlbums] = import_react23.default.useState(100);
    const [dropdown, activeOption] = useDropdownMenu_default(
      ["short_term", "medium_term", "long_term"],
      ["Past Month", "Past 6 Months", "All Time"],
      `top-albums`
    );
    const fetchTopAlbums2 = async (time_range, force, set = true) => {
      if (!force) {
        let storedData = LocalStorage.get(`stats:top-albums:${time_range}`);
        if (storedData) {
          setTopAlbums(JSON.parse(storedData));
          return;
        }
      }
      const start = window.performance.now();
      const topAlbums2 = await topAlbumsReq(time_range, config);
      if (set)
        setTopAlbums(topAlbums2);
      LocalStorage.set(`stats:top-albums:${time_range}`, JSON.stringify(topAlbums2));
      console.log("total albums fetch time:", window.performance.now() - start);
    };
    import_react23.default.useEffect(() => {
      updatePageCache(5, fetchTopAlbums2, activeOption);
    }, []);
    import_react23.default.useEffect(() => {
      fetchTopAlbums2(activeOption);
    }, [activeOption]);
    const props = {
      refreshCallback: () => fetchTopAlbums2(activeOption, true),
      config,
      dropdown
    };
    switch (topAlbums) {
      case 300:
        return /* @__PURE__ */ import_react23.default.createElement(page_container_default, {
          title: `Top Albums`,
          ...props
        }, /* @__PURE__ */ import_react23.default.createElement(status_default, {
          icon: "error",
          heading: "No API Key or Username",
          subheading: "Please enter these in the settings menu"
        }));
      case 200:
        return /* @__PURE__ */ import_react23.default.createElement(page_container_default, {
          title: `Top Albums`,
          ...props
        }, /* @__PURE__ */ import_react23.default.createElement(status_default, {
          icon: "error",
          heading: "Failed to Fetch Top Artists",
          subheading: "An error occurred while fetching the data"
        }));
      case 100:
        return /* @__PURE__ */ import_react23.default.createElement(page_container_default, {
          title: `Top Albums`,
          ...props
        }, /* @__PURE__ */ import_react23.default.createElement(status_default, {
          icon: "library",
          heading: "Loading",
          subheading: "Fetching data..."
        }));
    }
    const albumCards = topAlbums.map((album, index) => {
      const type = album.uri.startsWith("https") ? "lastfm" : "album";
      return /* @__PURE__ */ import_react23.default.createElement(spotify_card_default, {
        type,
        uri: album.uri,
        header: album.name,
        subheader: `#${index + 1} Album`,
        imageUrl: album.image
      });
    });
    return /* @__PURE__ */ import_react23.default.createElement(page_container_default, {
      title: "Top Albums",
      ...props
    }, /* @__PURE__ */ import_react23.default.createElement("div", {
      className: `main-gridContainer-gridContainer stats-grid`
    }, albumCards));
  };
  var top_albums_default = import_react23.default.memo(AlbumsPage);

  // package.json
  var version = "0.3.1";

  // src/constants.ts
  var STATS_VERSION = version;
  var LATEST_RELEASE = "https://api.github.com/repos/harbassan/spicetify-stats/releases";

  // src/components/hooks/useConfig.tsx
  var import_react25 = __toESM(require_react());

  // src/components/settings_modal.tsx
  var import_react24 = __toESM(require_react());
  var TextInput = (props) => {
    const textId = `text-input:${props.storageKey}`;
    return /* @__PURE__ */ import_react24.default.createElement("label", {
      className: "text-input-wrapper"
    }, /* @__PURE__ */ import_react24.default.createElement("input", {
      className: "text-input",
      type: "text",
      value: props.value || "",
      "data-storage-key": props.storageKey,
      placeholder: props.placeholder,
      id: textId,
      title: `Text input for ${props.storageKey}`,
      onChange: props.onChange
    }));
  };
  var Dropdown = (props) => {
    const dropdownId = `dropdown:${props.storageKey}`;
    return /* @__PURE__ */ import_react24.default.createElement("label", {
      className: "dropdown-wrapper"
    }, /* @__PURE__ */ import_react24.default.createElement("select", {
      className: "dropdown-input",
      value: props.value,
      "data-storage-key": props.storageKey,
      id: dropdownId,
      title: `Dropdown for ${props.storageKey}`,
      onChange: props.onChange
    }, props.options.map((option, index) => /* @__PURE__ */ import_react24.default.createElement("option", {
      key: index,
      value: option
    }, option))));
  };
  var TooltipIcon = () => {
    return /* @__PURE__ */ import_react24.default.createElement("svg", {
      role: "img",
      height: "16",
      width: "16",
      className: "Svg-sc-ytk21e-0 uPxdw nW1RKQOkzcJcX6aDCZB4",
      viewBox: "0 0 16 16"
    }, /* @__PURE__ */ import_react24.default.createElement("path", {
      d: "M8 1.5a6.5 6.5 0 100 13 6.5 6.5 0 000-13zM0 8a8 8 0 1116 0A8 8 0 010 8z"
    }), /* @__PURE__ */ import_react24.default.createElement("path", {
      d: "M7.25 12.026v-1.5h1.5v1.5h-1.5zm.884-7.096A1.125 1.125 0 007.06 6.39l-1.431.448a2.625 2.625 0 115.13-.784c0 .54-.156 1.015-.503 1.488-.3.408-.7.652-.973.818l-.112.068c-.185.116-.26.203-.302.283-.046.087-.097.245-.097.57h-1.5c0-.47.072-.898.274-1.277.206-.385.507-.645.827-.846l.147-.092c.285-.177.413-.257.526-.41.169-.23.213-.397.213-.602 0-.622-.503-1.125-1.125-1.125z"
    }));
  };
  var ConfigRow = (props) => {
    const enabled = !!props.modalConfig[props.storageKey];
    const value = props.modalConfig[props.storageKey];
    const updateItem = (storageKey, state) => {
      props.modalConfig[storageKey] = state;
      console.debug(`toggling ${storageKey} to ${state}`);
      localStorage.setItem(`stats:config:${storageKey}`, String(state));
      props.updateConfig(props.modalConfig);
    };
    const settingsToggleChange = (newValue, storageKey) => {
      updateItem(storageKey, newValue);
    };
    const settingsTextChange = (event) => {
      updateItem(event.target.dataset.storageKey, event.target.value);
    };
    const settingsDropdownChange = (event) => {
      updateItem(event.target.dataset.storageKey, event.target.value);
    };
    const element = () => {
      switch (props.type) {
        case "dropdown":
          return /* @__PURE__ */ import_react24.default.createElement(Dropdown, {
            name: props.name,
            storageKey: props.storageKey,
            value,
            options: props.options || [],
            onChange: settingsDropdownChange
          });
        case "text":
          return /* @__PURE__ */ import_react24.default.createElement(TextInput, {
            name: props.name,
            storageKey: props.storageKey,
            value,
            placeholder: props.placeholder,
            onChange: settingsTextChange
          });
        default:
          return /* @__PURE__ */ import_react24.default.createElement(Spicetify.ReactComponent.Toggle, {
            id: `toggle:${props.storageKey}`,
            value: enabled,
            onSelected: (newValue) => {
              settingsToggleChange(newValue, props.storageKey);
            }
          });
      }
    };
    return /* @__PURE__ */ import_react24.default.createElement("div", {
      className: "setting-row"
    }, /* @__PURE__ */ import_react24.default.createElement("label", {
      className: "col description"
    }, props.name, props.desc && /* @__PURE__ */ import_react24.default.createElement(Spicetify.ReactComponent.TooltipWrapper, {
      label: /* @__PURE__ */ import_react24.default.createElement("div", {
        dangerouslySetInnerHTML: { __html: props.desc }
      }),
      renderInline: true,
      showDelay: 10,
      placement: "top",
      labelClassName: "tooltip",
      disabled: false
    }, /* @__PURE__ */ import_react24.default.createElement("div", {
      className: "tooltip-icon"
    }, /* @__PURE__ */ import_react24.default.createElement(TooltipIcon, null)))), /* @__PURE__ */ import_react24.default.createElement("div", {
      className: "col action"
    }, element()));
  };
  var SettingsModal = ({ CONFIG, settings, updateAppConfig }) => {
    const [modalConfig, setModalConfig] = import_react24.default.useState({ ...CONFIG });
    const updateConfig = (CONFIG2) => {
      updateAppConfig({ ...CONFIG2 });
      setModalConfig({ ...CONFIG2 });
    };
    const configRows = settings.map((setting, index) => {
      if (setting.sectionHeader) {
        return /* @__PURE__ */ import_react24.default.createElement(import_react24.default.Fragment, null, index != 0 ? /* @__PURE__ */ import_react24.default.createElement("br", null) : /* @__PURE__ */ import_react24.default.createElement(import_react24.default.Fragment, null), /* @__PURE__ */ import_react24.default.createElement("h2", {
          className: "section-header"
        }, setting.sectionHeader), /* @__PURE__ */ import_react24.default.createElement(ConfigRow, {
          name: setting.name,
          storageKey: setting.key,
          type: setting.type,
          options: setting.options,
          placeholder: setting.placeholder,
          desc: setting.desc,
          modalConfig,
          updateConfig
        }));
      }
      return /* @__PURE__ */ import_react24.default.createElement(ConfigRow, {
        name: setting.name,
        storageKey: setting.key,
        type: setting.type,
        options: setting.options,
        placeholder: setting.placeholder,
        desc: setting.desc,
        modalConfig,
        updateConfig
      });
    });
    return /* @__PURE__ */ import_react24.default.createElement("div", {
      id: "stats-config-container"
    }, configRows);
  };
  var settings_modal_default = SettingsModal;

  // src/components/hooks/useConfig.tsx
  var getLocalStorageDataFromKey = (key, fallback) => {
    const data = localStorage.getItem(key);
    if (data) {
      try {
        return JSON.parse(data);
      } catch (err) {
        return data;
      }
    } else {
      return fallback;
    }
  };
  var useConfig = (settings) => {
    const settingsArray = settings.map((setting) => {
      return { [setting.key]: getLocalStorageDataFromKey(`stats:config:${setting.key}`, setting.def) };
    });
    const [CONFIG, setCONFIG] = import_react25.default.useState(Object.assign({}, ...settingsArray));
    const updateConfig = (config) => {
      setCONFIG({ ...config });
      console.log("updated config", config);
    };
    const launchModal = () => {
      Spicetify.PopupModal.display({
        title: "Statistics Settings",
        content: /* @__PURE__ */ import_react25.default.createElement(settings_modal_default, {
          CONFIG,
          settings,
          updateAppConfig: updateConfig
        }),
        isLarge: true
      });
    };
    return { CONFIG, launchModal };
  };
  var useConfig_default = useConfig;

  // src/app.tsx
  var pages = {
    ["Artists"]: /* @__PURE__ */ import_react26.default.createElement(top_artists_default, null),
    ["Tracks"]: /* @__PURE__ */ import_react26.default.createElement(top_tracks_default, null),
    ["Albums"]: /* @__PURE__ */ import_react26.default.createElement(top_albums_default, null),
    ["Genres"]: /* @__PURE__ */ import_react26.default.createElement(top_genres_default, null),
    ["Library"]: /* @__PURE__ */ import_react26.default.createElement(library_default, null),
    ["Charts"]: /* @__PURE__ */ import_react26.default.createElement(charts_default, null)
  };
  var checkForUpdates = (setNewUpdate) => {
    fetch(LATEST_RELEASE).then((res) => res.json()).then(
      (result) => {
        try {
          setNewUpdate(result[0].name.slice(1) !== STATS_VERSION);
        } catch (err) {
          console.log(err);
        }
      },
      (error) => {
        console.log("Failed to check for updates", error);
      }
    );
  };
  var App = () => {
    const config = useConfig_default([
      {
        name: "Last.fm Api Key",
        key: "api-key",
        type: "text",
        def: null,
        placeholder: "Enter API Key",
        desc: `You can get this by visiting www.last.fm/api/account/create and simply entering any name.<br/>You'll need to make an account first, which is a plus.`,
        sectionHeader: "Last.fm Integration"
      },
      {
        name: "Last.fm Username",
        key: "lastfm-user",
        type: "text",
        def: null,
        placeholder: "Enter Username"
      },
      {
        name: "Use Last.fm for Stats",
        key: "use-lastfm",
        type: "toggle",
        def: false,
        desc: `Last.fm charts your stats purely based on the streaming count, whereas Spotify factors in other variables`
      },
      { name: "Artists Page", key: "show-artists", type: "toggle", def: true, sectionHeader: "Pages" },
      { name: "Tracks Page", key: "show-tracks", type: "toggle", def: true },
      { name: "Albums Page", key: "show-albums", type: "toggle", def: false, desc: `Requires Last.fm API key and username` },
      { name: "Genres Page", key: "show-genres", type: "toggle", def: true },
      { name: "Library Page", key: "show-library", type: "toggle", def: true },
      { name: "Charts Page", key: "show-charts", type: "toggle", def: true, desc: `Requires Last.fm API key` }
    ]);
    const tabPages = ["Artists", "Tracks", "Albums", "Genres", "Library", "Charts"].filter((page) => config.CONFIG[`show-${page.toLowerCase()}`]);
    const [navBar, activeLink, setActiveLink] = useNavigationBar_default(tabPages);
    const [hasPageSwitched, setHasPageSwitched] = import_react26.default.useState(false);
    const [newUpdate, setNewUpdate] = import_react26.default.useState(false);
    import_react26.default.useEffect(() => {
      setActiveLink(Spicetify.LocalStorage.get("stats:active-link") || "Artists");
      checkForUpdates(setNewUpdate);
      setHasPageSwitched(true);
    }, []);
    import_react26.default.useEffect(() => {
      Spicetify.LocalStorage.set("stats:active-link", activeLink);
    }, [activeLink]);
    if (!hasPageSwitched) {
      return /* @__PURE__ */ import_react26.default.createElement(import_react26.default.Fragment, null);
    }
    return /* @__PURE__ */ import_react26.default.createElement(import_react26.default.Fragment, null, newUpdate && /* @__PURE__ */ import_react26.default.createElement("div", {
      className: "new-update"
    }, "New app update available! Visit ", /* @__PURE__ */ import_react26.default.createElement("a", {
      href: "https://github.com/harbassan/spicetify-stats/releases"
    }, "harbassan/spicetify-stats"), " to install."), navBar, import_react26.default.cloneElement(pages[activeLink], { config }));
  };
  var app_default = App;

  // node_modules/spicetify-creator/dist/temp/index.jsx
  var import_react27 = __toESM(require_react());
  function render() {
    return /* @__PURE__ */ import_react27.default.createElement(app_default, null);
  }
  return __toCommonJS(temp_exports);
})();
const render=()=>stats.default();
