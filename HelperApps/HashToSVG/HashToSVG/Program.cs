using System;

namespace HashToSVG
{
	class Program
	{
		static void Main(string[] args)
		{
			Console.WriteLine("Enter V3 hash:");

			string hash = Console.ReadLine();

			string svg = string.Empty;

			for (int i = 0; i < hash.Split(',').Length; i++)
			{
				string hashSplit = hash.Split(',')[i];

				svg += "<rect class='w" + hashSplit.Substring(0, 2) +
						"' x='" + hashSplit.Substring(2, 2) +
						"' y='" + hashSplit.Substring(4, 2) +
						"' width='" + hashSplit.Substring(6, 2) +
						"' height='" + hashSplit.Substring(8, 2) +
						"'/>";
			}

			Console.WriteLine(svg);
		}
	}
}
