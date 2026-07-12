# OmniAuth GatherPack

An [OmniAuth](https://github.com/omniauth/omniauth) 2.x strategy for authenticating against any [GatherPack](https://gatherpack.app) instance via its Doorkeeper-powered OAuth2 provider.

## Installation

```ruby
gem "omniauth-gather_pack"
```

## Usage

Register an OAuth application in your GatherPack instance at `/oauth_applications` with:

- **Redirect URI**: `https://yourapp.com/users/auth/gather_pack/callback`
- **Scopes**: `user_read user_email user_name`

Then wire it into Devise:

```ruby
# config/initializers/devise.rb
config.omniauth :gather_pack,
  ENV["GATHERPACK_CLIENT_ID"],
  ENV["GATHERPACK_CLIENT_SECRET"],
  client_options: { site: ENV["GATHERPACK_SITE"] }
```

Where `GATHERPACK_SITE` is the base URL of your GatherPack instance (e.g. `https://gatherpack.example.com`).

### Standalone Rack usage

```ruby
use OmniAuth::Builder do
  provider :gather_pack,
    ENV["GATHERPACK_CLIENT_ID"],
    ENV["GATHERPACK_CLIENT_SECRET"],
    client_options: { site: ENV["GATHERPACK_SITE"] }
end
```

## Auth hash

| Field        | Source                             |
|-------------|------------------------------------|
| `uid`       | `sub` from `/api/v1/userinfo` (neat_id) |
| `email`     | `email` (requires `user_email` scope)    |
| `name`      | `name` (requires `user_name` scope)      |
| `nickname`  | `preferred_username`                     |
| `urls.profile` | `profile` (person URL)              |

## License

MIT
