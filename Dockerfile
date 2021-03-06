FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["bot.csproj", "./"]
RUN dotnet restore "./bot.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "bot.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "bot.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
CMD ASPNETCORE_URLS=http://*:$PORT dotnet bot.dll
