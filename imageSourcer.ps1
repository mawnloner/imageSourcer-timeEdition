# set your Unsplash API access key
$accessKey = "CfZnnGq7i0VKZp_T8Bv2Q0Xo2fZrd_ZIh5bvNUFqTmM"

# parameter for filtering the images
$orientation = "landscape" # landscape, portrait, squarish (optional, but i reccomend landscape)

# create a header with the access key
$headers = @{
    "Accept-Version" = "v1"
    "Authorization"  = "Client-ID $accessKey"
}

# get the hour
$hour = (Get-Date).Hour

$outputPath = "C:\Users\remco\wallpaper\image.png" # change this to your desired output path

# case statement to determine the image to use
switch ($hour) {
    { $_ -ge 0 -and $_ -lt 6 } {
        # parameter for filtering the images
        $query = "Night"
    }
    { $_ -ge 6 -and $_ -lt 12 } {
        # parameter for filtering the images
        $query = "Morning"
    }
    { $_ -ge 12 -and $_ -lt 18 } {
        # parameter for filtering the images
        $query = "Afternoon"
    }
    { $_ -ge 18 -and $_ -lt 24 } {
        # parameter for filtering the images
        $query = "Evening"
        
    }
}

# full API endpoint for random photos
$endpoint = "https://api.unsplash.com/photos/random?query=$query&orientation=$orientation"

# make a GET request to the API endpoint
$response = Invoke-RestMethod -Uri $endpoint -Headers $headers

# extract the image URL from the response
$imageUrl = $response.urls.raw # raw, full, regular, small, thumb (raw is the highest quality)

# download the image using the URL
Invoke-WebRequest -Uri $imageUrl -OutFile $outputPath

# set the downloaded image as the wallpaper for the home screen
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class WallpaperSetter
{
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);

    public static void SetWallpaper(string imagePath)
    {
        const int SPI_SETDESKWALLPAPER = 0x0014;
        const int SPIF_UPDATEINIFILE = 0x01;
        const int SPIF_SENDCHANGE = 0x02;

        SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, imagePath, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);
    }
}
"@

[WallpaperSetter]::SetWallpaper($outputPath)