githook:
	cd .githooks
	chmod +x pre-commit
	chmod +x pre-push
	git config core.hooksPath .githooks
format:
	dart analyze
	dart run import_sorter:main
	dart format lib/
check-outdated:
	flutter pub outdated
upgrade:
	flutter pub upgrade --major-versions
pub-get:
	flutter clean
	flutter pub get
build-runner:
	dart run build_runner build -d
	dart run import_sorter:main
	dart fix --apply
generate-splash:
	dart run flutter_native_splash:create --path=native_splash_generator.yaml
generate-icon:
	dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
rename-app:
	dart run package_rename --path=package_rename_config.yaml

icons-to-webp-dry:
	DRY_RUN=1 bash scripts/convert_icons_to_webp.sh assets/icons assets/icons-old

icons-to-webp:
	bash scripts/convert_icons_to_webp.sh assets/icons assets/icons-old

index-entities:
	for d in lib/features/*/domain/entities; do \
		[ -d "$$d" ] || continue; \
		idx="$$d/index.dart"; \
		rm -f "$$idx"; \
		{ \
			main_files=$$(find "$$d" -maxdepth 1 -type f -name "*.dart" \
				! -name "*.g.dart" ! -name "*.freezed.dart" ! -name "index.dart" | sort); \
			for f in $$main_files; do \
				b=$$(basename "$$f"); \
				echo "export '$$b';"; \
			done; \
			enum_line_printed=""; \
			for sub in enum enums; do \
				subdir="$$d/$$sub"; \
				[ -d "$$subdir" ] || continue; \
				[ -n "$$main_files" ] && [ -z "$$enum_line_printed" ] && echo "" && enum_line_printed="1"; \
				if [ -f "$$subdir/index.dart" ]; then \
					echo "export '$$sub/index.dart';"; \
				else \
					for f in $$(find "$$subdir" -maxdepth 1 -type f -name "*.dart" \
						! -name "*.g.dart" ! -name "*.freezed.dart" ! -name "index.dart" | sort); do \
						b=$$(basename "$$f"); \
						echo "export '$$sub/$$b';"; \
					done; \
				fi; \
			done; \
			for subdir in $$(find "$$d" -mindepth 1 -maxdepth 1 -type d | sort); do \
				sub=$$(basename "$$subdir"); \
				[ "$$sub" = "enum" ] || [ "$$sub" = "enums" ] || true; \
				if [ "$$sub" = "enum" ] || [ "$$sub" = "enums" ]; then \
					continue; \
				fi; \
				sub_index="$$subdir/index.dart"; \
				rm -f "$$sub_index"; \
				for f in $$(find "$$subdir" -maxdepth 1 -type f -name "*.dart" \
					! -name "*.g.dart" ! -name "*.freezed.dart" ! -name "index.dart" | sort); do \
					b=$$(basename "$$f"); \
					echo "export '$$b';"; \
				done > "$$sub_index"; \
				echo "export '$$sub/index.dart';"; \
			done; \
		} > "$$idx"; \
	done

index-screens:
	for d in lib/features/*/presentation/screens; do \
		[ -d "$$d" ] || continue; \
		idx="$$d/index.dart"; \
		rm -f "$$idx"; \
		{ \
			for f in $$(find "$$d" -maxdepth 1 -type f -name "*.dart" \
				! -name "*.g.dart" ! -name "*.freezed.dart" ! -name "index.dart" | sort); do \
				b=$$(basename "$$f"); \
				echo "export '$$b';"; \
			done; \
		} > "$$idx"; \
	done

index-usecases:
	for d in lib/features/*/domain/usecases; do \
		[ -d "$$d" ] || continue; \
		idx="$$d/index.dart"; \
		rm -f "$$idx"; \
		{ \
			for f in $$(find "$$d" -maxdepth 1 -type f -name "*.dart" \
				! -name "*.g.dart" ! -name "*.freezed.dart" ! -name "index.dart" | sort); do \
				b=$$(basename "$$f"); \
				echo "export '$$b';"; \
			done; \
			for subdir in $$(find "$$d" -mindepth 1 -maxdepth 1 -type d | sort); do \
				sub=$$(basename "$$subdir"); \
				sub_index="$$subdir/index.dart"; \
				rm -f "$$sub_index"; \
				for f in $$(find "$$subdir" -maxdepth 1 -type f -name "*.dart" \
					! -name "*.g.dart" ! -name "*.freezed.dart" ! -name "index.dart" | sort); do \
					b=$$(basename "$$f"); \
					echo "export '$$b';"; \
				done > "$$sub_index"; \
				echo "export '$$sub/index.dart';"; \
			done; \
		} > "$$idx"; \
	done

index-widgets:
	for d in lib/features/*/presentation/widgets; do \
		[ -d "$$d" ] || continue; \
		idx="$$d/index.dart"; \
		rm -f "$$idx"; \
		{ \
			for f in $$(find "$$d" -maxdepth 1 -type f -name "*.dart" \
				! -name "*.g.dart" ! -name "*.freezed.dart" ! -name "index.dart" | sort); do \
				b=$$(basename "$$f"); \
				echo "export '$$b';"; \
			done; \
		} > "$$idx"; \
	done

index-all: index-entities index-screens index-widgets index-usecases
