using System;

namespace AttributeDebug
{
	class Program
	{
		static void Main(string[] args)
		{
			while (true)
			{
				Console.WriteLine("Enter attribute:");
				string attribute = Console.ReadLine();

				string svgRect = "<svg id='wojek-svg' xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 50 50'>";
				svgRect = svgRect + "<style>#wojek-svg{shape-rendering: crispedges;}.w10{fill:#000000}.w11{fill:#ffffff}.w12{fill:#00aaff}.w13{fill:#ff0000}.w14{fill:#ff7777}" +
									".w15{fill:#ff89b9}.w16{fill:#fff9e5}.w17{fill:#fff9d5}.w18{fill:#93c63b}.w19{fill:#ff6a00}.w20{fill:#808080}.w21{fill:#a94d00}.w22{fill:#00ffff}" +
									".w23{fill:#00ff00}.w24{fill:#B2B2B2}.w25{fill:#267F00}.w26{fill:#5B7F00}.w27{fill:#7F3300}.w28{fill:#A3A3A3}.w29{fill:#B78049}.w30{fill:#B5872B}" +
									".w31{fill:#565756}.w32{fill:#282828}.w33{fill:#8F7941}.w34{fill:#E3E5E4}.w35{fill:#6BBDD3}.w36{fill:#FFFF00}.w37{fill:#aaf2d1}.w38{fill:#6A6257}" +
									"</style>";

				for (int i = 0; i < attribute.Length / 10; i++)
				{
					string rect = attribute.Substring(i * 10, 10);

					svgRect = svgRect + "<rect class='w" + rect.Substring(0, 2) +
										"' x='" + rect.Substring(2, 2) +
										"' y='" + rect.Substring(4, 2) +
										"' width='" + rect.Substring(6, 2) +
										"' height='" + rect.Substring(8, 2) + 
										"'/>";
				}

				svgRect = svgRect + "</svg>";

				Console.Clear();
				Console.WriteLine(svgRect + "\n\n");
			}
		}
	}
}
