'use client';

import { useState, useEffect } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { supabase } from '@/lib/supabase';
import { Message, Conversation, User } from '@/types';
import { Send, ArrowLeft, MessageCircle, Clock } from 'lucide-react';

export default function ChatPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const sellerId = searchParams.get('seller') || '';

  const [conversations, setConversations] = useState<Conversation[]>([]);
  const [selectedConversation, setSelectedConversation] = useState<string | null>(null);
  const [messages, setMessages] = useState<Message[]>([]);
  const [newMessage, setNewMessage] = useState('');
  const [currentUser, setCurrentUser] = useState<User | null>(null);
  const [seller, setSeller] = useState<User | null>(null);

  useEffect(() => {
    fetchCurrentUser();
    if (sellerId) {
      startConversation(sellerId);
    } else {
      fetchConversations();
    }
  }, [sellerId]);

  const fetchCurrentUser = async () => {
    const { data: { session } } = await supabase.auth.getSession();
    if (session?.user) {
      const { data: userData } = await supabase
        .from('users')
        .select('*')
        .eq('id', session.user.id)
        .single();
      setCurrentUser(userData);
    }
  };

  const fetchConversations = async () => {
    if (!currentUser) return;

    const { data, error } = await supabase
      .from('conversations')
      .select('*')
      .or(`user_id.eq.${currentUser.id},seller_id.eq.${currentUser.id}`)
      .order('last_message_time', { ascending: false });

    if (error) console.error('Error fetching conversations:', error);
    else setConversations(data || []);
  };

  const startConversation = async (targetSellerId: string) => {
    if (!currentUser) return;

    // Check if conversation already exists
    const { data: existing } = await supabase
      .from('conversations')
      .select('*')
      .eq('user_id', currentUser.id)
      .eq('seller_id', targetSellerId)
      .single();

    if (existing) {
      setSelectedConversation(existing.id);
      fetchMessages(existing.id);
    } else {
      // Create new conversation
      const { data: newConv, error } = await supabase
        .from('conversations')
        .insert({
          user_id: currentUser.id,
          seller_id: targetSellerId,
          created_at: new Date().toISOString(),
        })
        .select()
        .single();

      if (error) console.error('Error creating conversation:', error);
      else {
        setSelectedConversation(newConv.id);
        fetchMessages(newConv.id);
      }
    }

    // Fetch seller info
    const { data: sellerData } = await supabase
      .from('users')
      .select('*')
      .eq('id', targetSellerId)
      .single();
    setSeller(sellerData);
  };

  const fetchMessages = async (conversationId: string) => {
    const { data, error } = await supabase
      .from('messages')
      .select('*')
      .eq('conversation_id', conversationId)
      .order('created_at', { ascending: true });

    if (error) console.error('Error fetching messages:', error);
    else setMessages(data || []);
  };

  const sendMessage = async () => {
    if (!newMessage.trim() || !selectedConversation || !currentUser) return;

    const { error } = await supabase.from('messages').insert({
      conversation_id: selectedConversation,
      sender_id: currentUser.id,
      receiver_id: seller?.id || '',
      content: newMessage,
      created_at: new Date().toISOString(),
      read: false,
    });

    if (error) {
      console.error('Error sending message:', error);
    } else {
      setNewMessage('');
      fetchMessages(selectedConversation);
    }
  };

  const formatTime = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleTimeString('es-CO', { hour: '2-digit', minute: '2-digit' });
  };

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="liquid-glass sticky top-0 z-50">
        <div className="container mx-auto px-4 py-4 flex items-center gap-4">
          <button
            onClick={() => router.back()}
            className="text-white hover:text-white/80 transition"
          >
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl font-bold text-white">
            {seller ? `Chat con ${seller.full_name || 'Profesional'}` : 'Mensajes'}
          </h1>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-6">
        {!selectedConversation ? (
          // Conversations List
          <div className="max-w-2xl mx-auto">
            <h2 className="text-2xl font-bold text-white mb-6">Tus Conversaciones</h2>
            {conversations.length === 0 ? (
              <div className="liquid-glass rounded-2xl p-12 text-center">
                <MessageCircle className="w-16 h-16 mx-auto mb-4 text-white/50" />
                <p className="text-white/70">
                  No tienes conversaciones aún. Ve a la sección de vendedores para iniciar un chat.
                </p>
              </div>
            ) : (
              <div className="space-y-4">
                {conversations.map((conv) => (
                  <button
                    key={conv.id}
                    onClick={() => {
                      setSelectedConversation(conv.id);
                      fetchMessages(conv.id);
                    }}
                    className="w-full liquid-glass rounded-xl p-4 text-left hover:bg-white/20 transition"
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-full glass-strong flex items-center justify-center">
                          <span className="text-xl">👷</span>
                        </div>
                        <div>
                          <h3 className="text-white font-semibold">
                            Conversación #{conv.id.slice(0, 8)}
                          </h3>
                          {conv.last_message && (
                            <p className="text-white/60 text-sm truncate">
                              {conv.last_message}
                            </p>
                          )}
                        </div>
                      </div>
                      {conv.last_message_time && (
                        <div className="flex items-center gap-1 text-white/50 text-sm">
                          <Clock className="w-3 h-3" />
                          {formatTime(conv.last_message_time)}
                        </div>
                      )}
                    </div>
                  </button>
                ))}
              </div>
            )}
          </div>
        ) : (
          // Chat View
          <div className="max-w-2xl mx-auto">
            <div className="liquid-glass rounded-2xl p-4 mb-4 h-[60vh] overflow-y-auto">
              {messages.length === 0 ? (
                <div className="text-center text-white/50 py-12">
                  <MessageCircle className="w-12 h-12 mx-auto mb-4" />
                  <p>Inicia la conversación</p>
                </div>
              ) : (
                <div className="space-y-4">
                  {messages.map((msg) => {
                    const isOwn = msg.sender_id === currentUser?.id;
                    return (
                      <div
                        key={msg.id}
                        className={`flex ${isOwn ? 'justify-end' : 'justify-start'}`}
                      >
                        <div
                          className={`max-w-[70%] px-4 py-2 rounded-2xl ${
                            isOwn
                              ? 'glass-strong text-white'
                              : 'glass text-white'
                          }`}
                        >
                          <p>{msg.content}</p>
                          <p className="text-xs text-white/50 mt-1">
                            {formatTime(msg.created_at)}
                          </p>
                        </div>
                      </div>
                    );
                  })}
                </div>
              )}
            </div>

            <div className="liquid-glass rounded-xl p-4">
              <div className="flex gap-2">
                <input
                  type="text"
                  value={newMessage}
                  onChange={(e) => setNewMessage(e.target.value)}
                  onKeyPress={(e) => e.key === 'Enter' && sendMessage()}
                  placeholder="Escribe un mensaje..."
                  className="flex-1 px-4 py-2 rounded-lg glass text-white placeholder-white/50 focus:outline-none focus:ring-2 focus:ring-white/50"
                />
                <button
                  onClick={sendMessage}
                  className="glass-strong px-4 py-2 rounded-lg text-white hover:bg-white/30 transition"
                >
                  <Send className="w-5 h-5" />
                </button>
              </div>
            </div>
          </div>
        )}
      </main>
    </div>
  );
}
