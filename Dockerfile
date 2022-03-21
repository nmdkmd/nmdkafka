FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS base
WORKDIR /app
EXPOSE 8080
#ENV ASPNETCORE_URLS=http://*:8080

FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
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
ENTRYPOINT ["dotnet", "KafkaTriggerReceiveProcess.dll"]
