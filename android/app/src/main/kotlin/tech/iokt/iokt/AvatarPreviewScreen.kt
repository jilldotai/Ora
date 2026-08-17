package tech.iokt.iokt

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

/**
 * A screen that displays an avatar preview, as shown in the design.
 * The background is a neutral grey, and the character is centered.
 */
@Composable
fun AvatarPreviewScreen(
    modifier: Modifier = Modifier
) {
    Surface(
        modifier = modifier.fillMaxSize(),
        color = Color(0xFFC0C0C0) // Neutral grey background from the screenshot
    ) {
        Box(
            modifier = Modifier.fillMaxSize(),
            contentAlignment = Alignment.Center
        ) {
            // Placeholder for the 3D character (Military Girl)
            // In a real implementation, this would be a 3D model renderer or a high-res image.
            CharacterPlaceholder(
                modifier = Modifier
                    .fillMaxHeight(0.8f)
                    .aspectRatio(0.6f)
            )
        }
    }
}

@Composable
fun CharacterPlaceholder(
    modifier: Modifier = Modifier
) {
    Box(
        modifier = modifier
            .background(Color.Gray.copy(alpha = 0.3f))
            .padding(16.dp),
        contentAlignment = Alignment.Center
    ) {
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            // Representing the character visually with a placeholder
            Box(
                modifier = Modifier
                    .size(120.dp)
                    .background(Color.DarkGray, shape = MaterialTheme.shapes.medium)
            )
            Spacer(modifier = Modifier.height(16.dp))
            Text(
                text = "Military Girl Avatar",
                style = MaterialTheme.typography.labelLarge,
                color = Color.DarkGray
            )
            Text(
                text = "T-Pose Preview",
                style = MaterialTheme.typography.bodySmall,
                color = Color.Gray
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
fun AvatarPreviewScreenPreview() {
    MaterialTheme {
        AvatarPreviewScreen()
    }
}
