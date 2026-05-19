import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmate/features/notes/presentation/widget/glass_bottom_navbar.dart';
import '../providers/navigation_provider.dart';
import 'add_note_page.dart'; // তোমার আগের তৈরি করা AddNotePage

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final filteredNotesState = ref.watch(filteredNotesProvider);

    return Scaffold(
      extendBody:
          true, // বটম ন্যাভবারের পেছনেও যেন বডি এক্সটেন্ড হতে পারে (গ্লাসমরফিজমের জন্য মাস্ট)
      appBar: AppBar(
        title: Text('TaskMate', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.push_pin_rounded),
            onPressed: () {
              // Pinned notes filter logic (Future Feature)
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          // TAB 1: Notes Layout with Integrated Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // SEARCH SECTION WIDGET
                TextField(
                  onChanged: (value) =>
                      ref.read(searchQueryProvider.notifier).state = value,
                  decoration: InputDecoration(
                    hintText: 'Search your thoughts...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.05),
                  ),
                ),
                const SizedBox(height: 16),
                // REACTIVE LIST VIEW SECTION
                Expanded(
                  child: filteredNotesState.when(
                    data: (notes) {
                      if (notes.isEmpty) {
                        return const Center(
                          child: Text(
                            'No items match your search or list is empty.',
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              title: Text(
                                note.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                note.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Icon(
                                note.isPinned
                                    ? Icons.push_pin
                                    : Icons.push_pin_outlined,
                                color: note.isPinned
                                    ? Colors.amber
                                    : Colors.grey,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(
                      child: Text(
                        'Error: $err',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // TAB 2: Todos Layout (Placeholder for next feature)
          const Center(
            child: Text(
              'Todos Module is coming in next session!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const GlassBottomNavbar(),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddNotePage()),
                );
              },
              child: const Icon(Icons.add),
            )
          : null, // শুধু নোট ট্যাবে থাকলেই প্লাস বাটন দেখাবে
    );
  }
}
