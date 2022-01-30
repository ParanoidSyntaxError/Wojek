using System;

namespace WojekStringToIntArray
{
	class Program
	{
		static void Main(string[] args)
		{
			while(true)
			{
				Console.WriteLine("Enter trait hash:");
				string svgHash = Console.ReadLine();

				string intArray = "[";

				for (int i = 0; i < svgHash.Length / 10; i++)
				{
					intArray = intArray + svgHash.Substring(i * 10, 10) + ",";
				}

				intArray = intArray.Remove(intArray.Length - 1) + "]";

				Console.WriteLine("\n" + intArray + "\n\n");
			}
		}
	}
}
