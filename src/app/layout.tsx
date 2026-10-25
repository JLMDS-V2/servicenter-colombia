import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "ServiCenter - Encuentra profesionales en Colombia",
  description: "Plataforma para encontrar electricistas, plomeros, cerrajeros y más profesionales del hogar en Colombia",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="es">
      <body className="gradient-bg min-h-screen">
        {children}
      </body>
    </html>
  );
}
