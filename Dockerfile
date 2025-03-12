# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copy and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o /publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /publish ./

# Expose port and run
EXPOSE 5174 7065
# HEALTHCHECK --interval=20s --timeout=15s --retries=3 CMD curl -f http://localhost:8080/up || exit 1

CMD ["dotnet", "SampleWebApp.dll"]
