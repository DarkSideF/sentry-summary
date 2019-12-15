# Tool for getting a summary of the sentry issues

Before using you need to set ENV variables into `.env` file.
```
API_TOKEN={YOUR_TOKEN}
BASE_URL={YOUR_URL}
ORGANIZATION={YOUR_ORG}
```

List all events
```rb
gg = SentrySummary::Sentry.new.events(1981355)
```