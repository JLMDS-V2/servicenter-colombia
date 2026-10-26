import type { Metadata } from "next";
import "./globals.css";
import { LocationProvider } from "@/contexts/LocationContext";

export const metadata: Metadata = {
  title: "ServiCenter - Encuentra profesionales en Colombia",
  description: "Plataforma para encontrar electricistas, plomeros, cerrajeros y más profesionales del hogar en Colombia",
  icons: {
    icon: '/icon.png',
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="es">
      <body className="gradient-bg min-h-screen">
        <LocationProvider>
          {children}
        </LocationProvider>
      </body>
    </html>
  );
}
