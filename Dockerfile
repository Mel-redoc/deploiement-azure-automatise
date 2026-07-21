FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY ["src/MonApi/MonApi.csproj", "src/MonApi/"]
RUN dotnet restore "src/MonApi/MonApi.csproj"
COPY . .
WORKDIR "/src/src/MonApi"
RUN dotnet publish "MonApi.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

USER $APP_UID

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "MonApi.dll"]
