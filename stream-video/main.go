package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strconv"
	"strings"
)

type VideoStreamer interface {
	Seek(key string, start, end int) ([]byte, error)
}

type MockVideoStreamer struct {
	Store map[string][]byte
}

func (m *MockVideoStreamer) Seek(key string, start, end int) ([]byte, error) {
	videoData, exists := m.Store[key]
	if !exists {
		return nil, fmt.Errorf("video not found for key %s", key)
	}

	if start < 0 || start > len(videoData) {
		return nil, fmt.Errorf("start byte %d out of range", start)
	}

	if end < start || end >= len(videoData) {
		end = len(videoData) - 1
	}

	return videoData[start : end+1], nil
}

func main() {
	videoData, err := readMovie("sample-5s.mp4")
	if err != nil {
		log.Fatal(err)
	}

	streamer := &MockVideoStreamer{
		Store: map[string][]byte{"video-key": videoData},
	}

	http.HandleFunc("/video", VideoStreamHandler(streamer, "video-key", len(videoData)))
	http.ListenAndServe(":8000", nil)
}

func VideoStreamHandler(streamer VideoStreamer, videoKey string, totalSize int) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		rangeHeader := r.Header.Get("Range")

		start, end := 0, 1024*1024-1

		if rangeHeader != "" {
			rangeParts := strings.TrimPrefix(rangeHeader, "bytes=")
			rangeValues := strings.Split(rangeParts, "-")
			var err error
			start, err = strconv.Atoi(rangeValues[0])
			if err != nil {
				http.Error(w, "invalid start byte", http.StatusBadRequest)
				return
			}
			if len(rangeValues) > 1 && rangeValues[1] != "" {
				end, err = strconv.Atoi(rangeValues[1])
				if err != nil {
					http.Error(w, "invalid end byte", http.StatusBadRequest)
				}
			} else {
				end = start + 1024*1024 - 1
			}
		}
		if end >= totalSize {
			end = totalSize - 1
		}

		videoData, err := streamer.Seek(videoKey, start, end)
		if err != nil {
			http.Error(
				w,
				fmt.Sprintf("Error retrieving video: %v", err),
				http.StatusInternalServerError,
			)
			return
		}

		w.Header().Set("Content-Range", fmt.Sprintf("bytes %d-%d/%d", start, end, totalSize))
		w.Header().Set("Accept-Ranges", "bytes")
		w.Header().Set("Content-Length", fmt.Sprintf("%d", len(videoData)))
		w.Header().Set("Content-Type", "video/mp4")
		w.WriteHeader(http.StatusPartialContent)
		_, err = w.Write(videoData)
		if err != nil {
			http.Error(w, "error streaming video", http.StatusInternalServerError)
		}
	}
}

func readMovie(movieFile string) ([]byte, error) {
	file, err := os.Open(movieFile)
	if err != nil {
		return nil, err
	}
	data, err := io.ReadAll(file)
	if err != nil {
		return nil, err
	}
	return data, nil
}
