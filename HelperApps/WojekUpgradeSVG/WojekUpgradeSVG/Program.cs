using System;

namespace WojekUpgradeSVG
{
	class Program
	{
		static void Main(string[] args)
		{
			while (true)
			{
				Console.WriteLine("Enter old SVG data below: ");
				string svgData = Console.ReadLine();

				/*
				string result = string.Empty;

				for (int i = 0; i < svgData.Split(',').Length; i++)
				{
					string splitSvg = svgData.Split(',')[i];

					result += "<rect class='w" + splitSvg.Substring(0, 2) + "' x='" + splitSvg.Substring(2, 2) + "' y='" + splitSvg.Substring(4, 2) + "' width='" + splitSvg.Substring(6, 2) + "' height='" + splitSvg.Substring(8, 2) + "'/>";
				}

				Console.WriteLine("\nResult:\n\n" + result + "\n");
				*/

				
				for (int i = 0; i < svgData.Length; i++)
				{
					if (svgData[i] == 'i')
					{
						svgData = svgData.Insert(i + 5, "0101");
						svgData = svgData.Remove(i, 1);
						i--;
					}
					else if (svgData[i] == 'r')
					{
						int x1 = int.Parse(svgData.Substring(i + 1, 2));
						int x2 = int.Parse(svgData.Substring(i + 5, 2));

						string width = (Math.Abs(x1 - x2) + 1).ToString();

						if (width.Length < 2)
						{
							width = "0" + width;
						}

						string x = svgData.Substring(i + 1, 2);

						if (x2 < x1)
						{
							x = svgData.Substring(i + 5, 2);
						}

						int y1 = int.Parse(svgData.Substring(i + 3, 2));
						int y2 = int.Parse(svgData.Substring(i + 7, 2));

						string height = (Math.Abs(y1 - y2) + 1).ToString();

						if (height.Length < 2)
						{
							height = "0" + height;
						}

						string y = svgData.Substring(i + 3, 2);

						if (y2 < y1)
						{
							y = svgData.Substring(i + 7, 2);
						}

						svgData = svgData.Remove(i, 9);

						svgData = svgData.Insert(i, x + y + width + height);

						i--;
					}
				}

				svgData = svgData.Replace('p', 'w');

				string newData = "";

				for (int i = 0; i < svgData.Length / 11; i++)
				{
					string data = svgData.Substring(i * 11, 11);

					//newData += "<rect class='w" + style.ToString() + "' x='" + data.Substring(0, 2) + "' y='" + data.Substring(2, 2) + "' width='" + data.Substring(4, 2) + "' height='" + data.Substring(6, 2) + "'/>";

					//newData += style.ToString() + data.Substring(0, 2) + data.Substring(2, 2) + data.Substring(4, 2) + data.Substring(6, 2) + ",";

					newData += data.Substring(9, 2) + data.Substring(0, 2) + data.Substring(2, 2) + data.Substring(4, 2) + data.Substring(6, 2);
				}



				//newData = (svgData.Length / 11).ToString() + ", " + newData.Remove(newData.Length - 1) + "]";

				/*
				string newData2 = string.Empty;

				for (int i = 0; i < newData.Length / 35; i++)
				{
					string data = newData.Substring(i * 35, 35);

					newData2 += "<rect class='w" + data + "'/>";
				}
				*/

				Console.WriteLine("\nResult:\n\n" + newData + "\n");
			}
		}
	}
}
