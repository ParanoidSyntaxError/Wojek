using System;

namespace RandomHash
{
	class Program
	{
		static Random rng = new Random();

		static int noonce;

		static void Main(string[] args)
		{
			int[] attributeLengths =
			{ 
				4,	//Backgrounds
				4,	//Characters
				5,	//Beards
				7,	//Foreheads
				9,	//Mouths
				8,	//Eyes
				6,	//Noses
				10,	//Hats
				7,	//Accessories
			};

			while(true)
			{
				Console.WriteLine("Press enter for a new hash (" + noonce + "):");
				Console.ReadLine();

				string hash = "1";

				for (int i = 0; i < attributeLengths.Length; i++)
				{
					int attributeIndex = rng.Next(0, attributeLengths[i]);

					if (attributeIndex < 10)
					{
						hash = hash + "00" + attributeIndex.ToString();
					}
					else if (attributeIndex < 100)
					{
						hash = hash + "0" + attributeIndex.ToString();
					}
					else
					{
						hash = hash + attributeIndex.ToString();
					}
				}

				if (rng.Next(0, 100) < 10)
				{
					hash = hash + "001";
				}
				else
				{
					hash = hash + "000";
				}

				Console.WriteLine(hash + "\n\n");
				noonce++;
			}
		}
	}
}
