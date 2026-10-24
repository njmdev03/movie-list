CREATE TABLE
    IF NOT EXISTS users (
        id uuid PRIMARY KEY DEFAULT gen_random_uuid (),

        created_at timestamptz NOT NULL DEFAULT now ()
    );

CREATE TABLE
    IF NOT EXISTS logins (
        id uuid PRIMARY KEY DEFAULT gen_random_uuid (),

        user_id uuid NOT NULL REFERENCES users (id),

        login_at timestamptz NOT NULL DEFAULT now ()
    );

CREATE TABLE
    IF NOT EXISTS assets (
        id uuid PRIMARY KEY DEFAULT gen_random_uuid (),

        asset_path text NOT NULL,

        created_at timestamptz NOT NULL DEFAULT now (),
        created_by uuid NOT NULL REFERENCES users (id)
    );

CREATE TABLE
    IF NOT EXISTS providers (
        id uuid PRIMARY KEY DEFAULT gen_random_uuid (),

        name text NOT NULL UNIQUE
    );

CREATE TABLE
    IF NOT EXISTS lists (
        id uuid PRIMARY KEY DEFAULT gen_random_uuid (),

        owner_id uuid NOT NULL REFERENCES users (id),
        created_at timestamptz NOT NULL DEFAULT now (),

        name text NOT NULL,
        description text,

        background uuid REFERENCES assets (id),
        icon uuid REFERENCES assets (id)
    );

CREATE TABLE
    IF NOT EXISTS list_user_shares (
        list_id uuid NOT NULL REFERENCES lists (id),
        user_id uuid NOT NULL REFERENCES users (id),
        PRIMARY KEY (list_id, user_id)
    );

CREATE TABLE
    IF NOT EXISTS list_server_shares (
        list_id uuid NOT NULL REFERENCES lists (id),
        server_id text NOT NULL,
        PRIMARY KEY (list_id, server_id)
    );

CREATE TABLE
    IF NOT EXISTS list_items (
        id uuid NOT NULL DEFAULT gen_random_uuid (),
        list_id uuid NOT NULL REFERENCES lists (id),

        PRIMARY KEY (id, list_id),

        -- TODO: Need to store two types of items: items with resources and data provided by external providers and manually entered items.

        provider uuid REFERENCES providers (id),
        item_id text,

        added_at timestamptz NOT NULL DEFAULT now (),
        added_by uuid NOT NULL REFERENCES users (id)
    );

CREATE TABLE
    IF NOT EXISTS item_reactions (
        id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
        list uuid NOT NULL REFERENCES lists (id),
        UNIQUE (id, list),

        name text NOT NULL,
        asset uuid NOT NULL REFERENCES assets (id),

        added_at timestamptz NOT NULL DEFAULT now (),
        added_by uuid NOT NULL REFERENCES users (id)
    );

CREATE TABLE
    IF NOT EXISTS item_reaction_events (
        list uuid NOT NULL REFERENCES lists (id),
        provider uuid NOT NULL REFERENCES providers (id),
        item text NOT NULL,

        FOREIGN KEY (list, provider, item)
            REFERENCES list_items (list, provider, item),

        reaction uuid NOT NULL REFERENCES item_reactions (id),

        FOREIGN KEY (reaction, list)
            REFERENCES item_reactions (id, list),

        user_id uuid NOT NULL REFERENCES users (id),

        PRIMARY KEY (list, provider, item, user_id, reaction),

        reacted_at timestamptz NOT NULL DEFAULT now ()
    );