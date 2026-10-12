import { type RouteConfig, index, prefix, route } from "@react-router/dev/routes";

// export default [index("routes/home.tsx")] satisfies RouteConfig;

export default [
  index("routes/home.tsx"),
  // route("api", ""),
  // route("docs", ""),
  route("app", "routes/app.tsx", [
    // route("login", "routes/app/login.tsx"),
    // route("profile", "routes/app/profile.tsx"),

    ...prefix("lists", [
      // index("routes/app/lists/home.tsx"),
      route("library", "routes/app/lists/library.tsx"),
      route("shared", "routes/app/lists/shared.tsx"),
      route("servers", "routes/app/lists/servers.tsx"),
    ]),

    route("list/:id", "routes/app/list.tsx", [
      route("settings", "routes/app/list/settings.tsx"),
      route("share", "routes/app/list/share.tsx"),
    ]),
  ]),
] satisfies RouteConfig;

