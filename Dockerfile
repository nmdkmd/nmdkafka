FROM mcr.microsoft.com/dotnet/aspnet:3.0 AS base
#RUN mkdir app
#COPY /src/* /app/
WORKDIR /app
EXPOSE 8080
#ENV ASPNETCORE_URLS=http://*:8080

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
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
