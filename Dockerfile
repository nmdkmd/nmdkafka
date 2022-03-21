FROM mcr.microsoft.com/azure-functions/dotnet:3.1.0-appservice AS base
WORKDIR /app
EXPOSE 8080
#ENV ASPNETCORE_URLS=http://*:8080

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["KafkaTriggerReceiveProcess.csproj", "."]
RUN dotnet restore "./KafkaTriggerReceiveProcess.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "KafkaTriggerReceiveProcess.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "KafkaTriggerReceiveProcess.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["/snap/bin/dotnet","KafkaTriggerReceiveProcess.dll"]
