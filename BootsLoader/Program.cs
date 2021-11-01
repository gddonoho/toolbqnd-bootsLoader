using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using Newtonsoft.Json.Linq;
using Npgsql;

namespace BootsLoader
{
    class Program
    {
        static void Main(string[] args)
        {
            //load tdp scrape data
            string json = File.ReadAllText("boots.json");
            JArray boots = JArray.Parse(json);
            //load best show into hash
            HashSet<string> bestshows = new HashSet<string>();
            foreach (string line in File.ReadLines("bestshows.txt"))
            {
                bestshows.Add(line);
            }
            //save to database
            var connectionString = ConfigurationManager.ConnectionStrings["PGDB"].ConnectionString;
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();
                DateTime date;
                int i, version, concertId, recordingId;
                foreach (var boot in boots)
                {
                    if (!DateTime.TryParse(boot["date"].ToString(), out date)) continue;
                    if (!Int32.TryParse(boot["version"].ToString(), out version)) continue;
                    if (!bestshows.Contains($"{date.ToString("yyyy-MM-dd")}|{version}")) continue;
                    var command = $"select concertid from concert where concertdate = '{date.ToString("yyyy-MM-dd")}'";
                    using (NpgsqlCommand comm = new NpgsqlCommand(command, connection))
                    {
                        concertId = Int32.Parse(comm.ExecuteScalar().ToString());
                    }
                    command = $"insert into recording (concertId, linkurl) values ({concertId}, '{boot["link"]}') returning recordingid";
                    using (NpgsqlCommand comm = new NpgsqlCommand(command, connection))
                    {
                        recordingId = Int32.Parse(comm.ExecuteScalar().ToString());
                    }
                    var links = JArray.Parse(boot["songs"].ToString());
                    i = 0;
                    foreach (var link in links)
                    {
                        i++;
                        command = $"insert into mp3link (recordingid, songorder, linkurl) values ({recordingId}, {i}, '{link[i.ToString()]}')";
                        using (NpgsqlCommand comm = new NpgsqlCommand(command, connection))
                        {
                            _ = comm.ExecuteNonQuery();
                        }
                    }
                    Console.WriteLine($"Imported {date.ToShortDateString()} version {version} with {i} links");
                }
            }
            Console.WriteLine("Import complete");
        }
    }
}
