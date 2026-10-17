import { type RouteConfig, index, layout, prefix, route } from "@react-router/dev/routes";

// export default [index("routes/home.tsx")] satisfies RouteConfig;

export default [
  index("routes/home.tsx"),
  // route("api", ""),
  // route("docs", ""),
  ...prefix("app", [
    // route("login", "routes/app/login.tsx"),

    layout("routes/app/applayout.tsx", [
      // route("profile", "routes/app/profile.tsx"),

      ...prefix("lists", [
        // index("routes/app/lists/home.tsx"),
        route("library", "routes/app/lists/library.tsx"),
        route("shared", "routes/app/lists/shared.tsx"),
        route("servers", "routes/app/lists/servers.tsx"),
        // route("discover", "routes/app/lists/discover.tsx"),
      ]),
    ]),

    ...prefix("list/:id", [
      // Add list layout route to add background to all three paths
      index("routes/app/list/list.tsx"),
      route("settings", "routes/app/list/settings.tsx"),
      route("share", "routes/app/list/share.tsx"),
    ]),
  ]),
] satisfies RouteConfig;

