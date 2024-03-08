FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine-amd64 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine3.19-amd64 AS build
WORKDIR /src
COPY ["BlazorApp/BlazorApp.csproj", "."]
RUN dotnet restore "BlazorApp/BlazorApp.csproj"
COPY . .
RUN dotnet build "BlazorApp/BlazorApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BlazorApp/BlazorApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BlazorApp.dll"]
