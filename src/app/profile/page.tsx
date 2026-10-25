'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { supabase } from '@/lib/supabase';
import { User, Seller } from '@/types';
import { categories } from '@/lib/data';
import { Save, ArrowLeft, Shield, Star, LogOut, MapPin, Phone, MessageCircle, Check } from 'lucide-react';

export default function ProfilePage() {
  const router = useRouter();
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  // Profile fields
  const [fullName, setFullName] = useState('');
  const [phone, setPhone] = useState('');
  const [city, setCity] = useState('');
  const [description, setDescription] = useState('');
  const [whatsapp, setWhatsapp] = useState('');
  const [preferredContact, setPreferredContact] = useState<'whatsapp' | 'chat' | 'both'>('both');
  const [selectedCategories, setSelectedCategories] = useState<string[]>([]);

  useEffect(() => {
    fetchUser();
  }, []);

  const fetchUser = async () => {
    const { data: { session } } = await supabase.auth.getSession();
    if (session?.user) {
      const { data: userData } = await supabase
        .from('users')
        .select('*')
        .eq('id', session.user.id)
        .single();
      setUser(userData);

      if (userData) {
        setFullName(userData.full_name || '');
        setPhone(userData.phone || '');
        setCity(userData.city || '');
        setDescription((userData as Seller).description || '');
        setWhatsapp((userData as Seller).whatsapp || '');
        setPreferredContact((userData as Seller).preferred_contact || 'both');
        setSelectedCategories((userData as Seller).categories || []);
      }
    } else {
      router.push('/auth');
    }
    setLoading(false);
  };

  const handleSave = async () => {
    if (!user) return;
    setSaving(true);

    try {
      const updateData: any = {
        full_name: fullName,
        phone: phone,
        city: city,
      };

      if (user.role === 'seller') {
        updateData.description = description;
        updateData.whatsapp = whatsapp;
        updateData.preferred_contact = preferredContact;
        updateData.categories = selectedCategories;
      }

      const { error } = await supabase
        .from('users')
        .update(updateData)
        .eq('id', user.id);

      if (error) throw error;

      alert('Perfil actualizado exitosamente');
    } catch (err) {
      console.error('Error saving profile:', err);
      alert('Error al guardar el perfil');
    } finally {
      setSaving(false);
    }
  };

  const toggleCategory = (categoryId: string) => {
    setSelectedCategories(prev =>
      prev.includes(categoryId)
        ? prev.filter(id => id !== categoryId)
        : [...prev, categoryId]
    );
  };

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.push('/');
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-white"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="liquid-glass sticky top-0 z-50">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <button
              onClick={() => router.back()}
              className="text-white hover:text-white/80 transition"
            >
              <ArrowLeft className="w-6 h-6" />
            </button>
            <h1 className="text-xl font-bold text-white">Mi Perfil</h1>
          </div>
          <button
            onClick={handleLogout}
            className="glass px-4 py-2 rounded-lg text-white hover:bg-white/20 transition flex items-center gap-2"
          >
            <LogOut className="w-4 h-4" />
            Cerrar Sesión
          </button>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-12">
        <div className="max-w-2xl mx-auto">
          <div className="liquid-glass rounded-2xl p-8">
            <div className="mb-8">
              <div className="flex items-center gap-4 mb-4">
                <div className="w-20 h-20 rounded-full glass-strong flex items-center justify-center">
                  <span className="text-4xl">👤</span>
                </div>
                <div>
                  <h2 className="text-2xl font-bold text-white">
                    {fullName || 'Tu Nombre'}
                  </h2>
                  <p className="text-white/70">{user?.email}</p>
                  <div className="flex items-center gap-2 mt-2">
                    <span className={`px-3 py-1 rounded-full text-sm ${
                      user?.role === 'seller' ? 'bg-green-500/20 text-green-300' : 'bg-blue-500/20 text-blue-300'
                    }`}>
                      {user?.role === 'seller' ? 'Vendedor' : 'Usuario'}
                    </span>
                    {(user as Seller)?.is_verified && (
                      <div className="flex items-center gap-1 text-green-400">
                        <Shield className="w-4 h-4" />
                        <Check className="w-4 h-4" />
                        <span className="text-sm">Verificado</span>
                      </div>
                    )}
                  </div>
                </div>
              </div>
            </div>

            <div className="space-y-6">
              {/* Full Name */}
              <div>
                <label className="block text-white mb-2 flex items-center gap-2">
                  Nombre Completo
                </label>
                <input
                  type="text"
                  value={fullName}
                  onChange={(e) => setFullName(e.target.value)}
                  className="w-full px-4 py-3 rounded-xl glass text-white placeholder-white/50 focus:outline-none focus:ring-2 focus:ring-white/50"
                  placeholder="Tu nombre completo"
                />
              </div>

              {/* Phone */}
              <div>
                <label className="block text-white mb-2 flex items-center gap-2">
                  <Phone className="w-4 h-4" />
                  Teléfono
                </label>
                <input
                  type="tel"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  className="w-full px-4 py-3 rounded-xl glass text-white placeholder-white/50 focus:outline-none focus:ring-2 focus:ring-white/50"
                  placeholder="+57 300 123 4567"
                />
              </div>

              {/* City */}
              <div>
                <label className="block text-white mb-2 flex items-center gap-2">
                  <MapPin className="w-4 h-4" />
                  Ciudad
                </label>
                <input
                  type="text"
                  value={city}
                  onChange={(e) => setCity(e.target.value)}
                  className="w-full px-4 py-3 rounded-xl glass text-white placeholder-white/50 focus:outline-none focus:ring-2 focus:ring-white/50"
                  placeholder="Tu ciudad"
                />
              </div>

              {/* Seller-specific fields */}
              {user?.role === 'seller' && (
                <>
                  <div className="border-t border-white/20 pt-6">
                    <h3 className="text-xl font-bold text-white mb-4">
                      Configuración de Vendedor
                    </h3>

                    {/* Description */}
                    <div className="mb-6">
                      <label className="block text-white mb-2">Descripción</label>
                      <textarea
                        value={description}
                        onChange={(e) => setDescription(e.target.value)}
                        rows={4}
                        className="w-full px-4 py-3 rounded-xl glass text-white placeholder-white/50 focus:outline-none focus:ring-2 focus:ring-white/50"
                        placeholder="Describe tus servicios, experiencia, horarios..."
                      />
                    </div>

                    {/* WhatsApp */}
                    <div className="mb-6">
                      <label className="block text-white mb-2 flex items-center gap-2">
                        WhatsApp
                      </label>
                      <input
                        type="tel"
                        value={whatsapp}
                        onChange={(e) => setWhatsapp(e.target.value)}
                        className="w-full px-4 py-3 rounded-xl glass text-white placeholder-white/50 focus:outline-none focus:ring-2 focus:ring-white/50"
                        placeholder="+57 300 123 4567"
                      />
                    </div>

                    {/* Preferred Contact */}
                    <div className="mb-6">
                      <label className="block text-white mb-2">Método de Contacto Preferido</label>
                      <select
                        value={preferredContact}
                        onChange={(e) => setPreferredContact(e.target.value as any)}
                        className="w-full px-4 py-3 rounded-xl glass text-white focus:outline-none focus:ring-2 focus:ring-white/50"
                      >
                        <option value="both" className="bg-gray-800">Ambos (WhatsApp y Chat)</option>
                        <option value="whatsapp" className="bg-gray-800">Solo WhatsApp</option>
                        <option value="chat" className="bg-gray-800">Solo Chat Interno</option>
                      </select>
                    </div>

                    {/* Categories */}
                    <div className="mb-6">
                      <label className="block text-white mb-2">Categorías de Servicios</label>
                      <div className="grid grid-cols-2 gap-3">
                        {categories.map((cat) => (
                          <button
                            key={cat.id}
                            type="button"
                            onClick={() => toggleCategory(cat.id)}
                            className={`p-3 rounded-xl text-left transition ${
                              selectedCategories.includes(cat.id)
                                ? 'glass-strong text-white'
                                : 'glass text-white/70 hover:text-white'
                            }`}
                          >
                            <div className="flex items-center gap-2">
                              <span>{cat.icon}</span>
                              <span className="text-sm">{cat.name}</span>
                              {selectedCategories.includes(cat.id) && (
                                <Check className="w-4 h-4 ml-auto" />
                              )}
                            </div>
                          </button>
                        ))}
                      </div>
                    </div>
                  </div>
                </>
              )}

              {/* Save Button */}
              <button
                onClick={handleSave}
                disabled={saving}
                className="w-full glass-strong px-6 py-3 rounded-xl text-white font-semibold hover:bg-white/30 transition disabled:opacity-50 flex items-center justify-center gap-2"
              >
                <Save className="w-5 h-5" />
                {saving ? 'Guardando...' : 'Guardar Cambios'}
              </button>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
