
# Build

```
dotnet build -c Release
```

# Publish

```
dotnet publish -c Release -r win-x64 --self-contained false /p:PublishSingleFile=true /p:PublishReadyToRun=true
```

