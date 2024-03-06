# create build container containing sdk
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine3.19-amd64 AS build
WORKDIR /source
COPY /BlazorApp.sln /source/
COPY /src /source/src
RUN dotnet publish BlazorApp.sln --configfile Nuget.config -c Debug -o /app

# create base container with runtime
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine3.19-amd64 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
RUN apk add --no-cache icu-libs
RUN apk add --no-cache tzdata
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT false

# create final container to deployed application
FROM base AS final
WORKDIR /app
COPY --from=build /app .
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
ENV ASPNETCORE_URLS=http://+;https://+
ENTRYPOINT ["dotnet", "BlazorApp.dll"]
