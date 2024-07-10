# Use the official ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Use the official .NET SDK to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY "webapi-docker.csproj" .
RUN dotnet restore "webapi-docker.csproj"
COPY . .
RUN dotnet build "webapi-docker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "webapi-docker.csproj" -c Release -o /app/publish

# Copy the build and published files to the runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "webapi-docker.dll"]
